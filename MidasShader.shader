Shader "Custom/MidasShader"
{
    Properties
    {
        _SpreadSpeed ("Spread Speed", Float) = 1.0              // How fast the gold effect spreads
        _BaseColor ("Initial Color", Color) = (1,1,1,1)      // Default object color before turning to gold
        _Shininess ("Shininess", Float) = 64.0                  // Controls the size of the specular highlight
        _Reflectivity ("Reflectivity", Float) = 0.5             // How reflective the object appears (affects specular)
    }

    SubShader
    {
        // These define how the object is rendered
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        ZWrite On      
        ZTest LEqual         
        Cull Back

        Pass
        {
            CGPROGRAM
            #pragma vertex vert                  
            #pragma fragment frag                
            #pragma multi_compile_fwdbase        

            #include "UnityCG.cginc"             
            #include "Lighting.cginc"           

            // Shader properties
            float3 _ClickPos;                    // World position where the user clicked
            float _StartTime;                    // Time when the effect started
            float _SpreadSpeed;                  // Speed of gold spreading
            fixed4 _BaseColor;                   // Original object color
            float _Shininess;                    // Controls specular highlight sharpness
            float _Reflectivity;                 // Intensity of the specular highlight

            // Vertex input structure
            struct appdata
            {
                float4 vertex : POSITION;       
                float3 normal : NORMAL;        
            };

            // Data passed from vertex to fragment shader
            struct v2f
            {
                float4 pos : SV_POSITION;        // Clip space position for rendering
                float3 worldPos : TEXCOORD0;     // World position of the vertex
                float3 normal : TEXCOORD1;       // Normal in world space
                float3 viewDir : TEXCOORD2;      // Direction from pixel to camera
            };

            // Vertex Shader: transforms data for the fragment shader
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);                           // Convert vertex to clip space
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;              // Convert vertex to world space
                o.normal = UnityObjectToWorldNormal(v.normal);                    // Convert normal to world space
                o.viewDir = normalize(_WorldSpaceCameraPos - o.worldPos);         // Calculate view direction
                return o;
            }

            // Fragment Shader: calculates the final pixel color
            fixed4 frag (v2f i) : SV_Target
            {
                // Normalize incoming data
                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);            // Direction to main directional light
                float3 viewDir = normalize(i.viewDir);
                float3 halfDir = normalize(lightDir + viewDir);                   // Halfway vector for specular

                // Basic diffuse and specular lighting
                float NdotL = max(0, dot(normal, lightDir));                      // Diffuse lighting
                float specular = pow(max(dot(normal, halfDir), 0.0), _Shininess)  // Specular highlight
                                * _Reflectivity;

                fixed4 finalColor = _BaseColor * NdotL;                           // Initial lighting using base color

                // If the gold effect has started
                if (_StartTime > 0)
                {
                    // Compute how far this pixel is from the clicked point
                    float dist = distance(i.worldPos, _ClickPos);

                    // Time since the gold effect started
                    float timeElapsed = _Time.y - _StartTime;

                    // Each pixel has its own start time based on distance
                    float pixelStartTime = timeElapsed - (dist / _SpreadSpeed);

                    // If this pixel's time has come, show gold
                    float goldAmount = step(0, pixelStartTime); // 0 or 1

                    // Gold color (RGB = gold tone)
                    fixed4 goldColor = fixed4(1.0, 0.84, 0.0, 1.0); // Classic gold

                    float ambientLight = 0.3; // Minimal light to keep gold visible in dark
                    float lighting = max(ambientLight, NdotL + specular); // Total lighting

                    // Blend between base color and gold based on goldAmount (0 or 1)
                    finalColor = lerp(finalColor, goldColor * lighting + goldColor * 0.1, goldAmount);
                }

                return finalColor; // Output the final pixel color
            }
            ENDCG
        }
    }
}
