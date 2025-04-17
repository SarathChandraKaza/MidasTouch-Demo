using UnityEngine;

public class ObjectDataSender : MonoBehaviour
{
    private MaterialPropertyBlock propertyBlock;
    private Renderer objRenderer;

    // Flag to make sure the click is only registered once
    private bool hasClicked = false;
    
    void Start()
    {
        objRenderer = GetComponent<Renderer>();             
        propertyBlock = new MaterialPropertyBlock();      
    }
    void Update()
    {
        // Check if the left mouse button was pressed
        if (Input.GetMouseButtonDown(0)) 
        {
            // Create a ray from the mouse cursor into the 3D scene
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            // Perform a raycast to detect what the ray hits
            if (Physics.Raycast(ray, out hit) && 
                hit.collider.gameObject == gameObject &&   // Make sure we clicked this specific object
                !hasClicked)                               // Only allow the first click
            {
                hasClicked = true;                         // Prevent future clicks from triggering again

                Vector3 clickPosition = hit.point;         // Get the exact point where the object was clicked

                // Get the current MaterialPropertyBlock of the object
                objRenderer.GetPropertyBlock(propertyBlock);

                // Send the world click position to the shader as a Vector4
                propertyBlock.SetVector("_ClickPos", new Vector4(clickPosition.x, clickPosition.y, clickPosition.z, 1));

                // Send the current time to the shader as the start time
                propertyBlock.SetFloat("_StartTime", Time.time);

                // Apply the updated properties back to the renderer
                objRenderer.SetPropertyBlock(propertyBlock);
            }
        }
    }
    
    void OnDisable()
    {
        hasClicked = false; // Reset the click flag

        // Clear the custom shader properties so the effect resets
        objRenderer.GetPropertyBlock(propertyBlock);
        propertyBlock.SetFloat("_StartTime", 0);
        propertyBlock.SetVector("_ClickPos", Vector4.zero);
        objRenderer.SetPropertyBlock(propertyBlock);
    }
}
