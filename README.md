# Midas Touch Shader : Turning Objects to Gold on Click

This project showcases a custom **HLSL shader in Unity** that creates a magical "Midas Touch" effect — clicking on a 3D object turns it into gold, starting from the click point and spreading outwards over time.

---

## What is the Midas Touch Shader?

The **Midas Touch Shader** simulates a visual effect where a golden transformation spreads across an object. It does this procedurally — without using textures — relying purely on mathematical distance from a click point and time calculations.

When you click on a 3D object using the mouse:
- The point of the click is recorded and sent to the shader.
- From that point, a **spreading radius** is calculated based on time.
- Pixels within the spreading range gradually turn into a glowing **golden color** with lighting and reflectivity.

---

## How the Shader Works (Simplified)

1. **Click Detection:** The click position is recorded in **world space** and the current time is stored.
2. **Distance Calculation:** In the fragment shader, each pixel calculates its distance from the click point.
3. **Gold Spread Logic:**
   - Pixels check how long ago the spread started.
   - If the time is enough for the gold to have reached them (based on speed), they switch to gold.
4. **Lighting:** Diffuse and specular highlights are calculated for both base and gold colors for realism.

---

## How to Set It Up in Unity

Follow these steps to apply the Midas Touch Shader to a 3D mesh:

![image](https://github.com/user-attachments/assets/e34092c2-115a-4983-a2f9-2d27593549c3)

### 1. **Import Your 3D Model**
- Import the 3D model of the swing (e.g., FBX, OBJ, etc.).
- Drag and drop it into your **Hierarchy**.

### 2. **Create the Shader and Material**
- Create a new **Shader** in the Project view and paste in the `MidasTouch` shader code.
- Create a new **Material**.
  - Assign the custom shader: `Shader > Custom > MidasShader`.
  - Optionally, tweak properties like:
    - **Base Color** – original color of the mesh
    - **Spread Speed** – how fast the gold spreads
    - **Shininess** – sharpness of the highlight
    - **Reflectivity** – intensity of the specular effect

### 3. **Apply the Material to the Mesh**
- Select the 3D swing in the Hierarchy.
- Drag the newly created **material** onto the mesh in the Inspector.

### 4. **Add Collider for Click Detection**
- With the swing selected, go to `Component > Physics > Mesh Collider`.
- This allows the object to receive mouse clicks using raycasting.

### 5. **Attach the Script**
- Create a new C# script named `ObjectDataSender`.
- Paste in the `ObjectDataSender` script code (handles click detection and communication with the shader).
- Attach the script to the same swing GameObject.

### 6. **Press Play**
- Enter **Play Mode**.
- Click anywhere on the swing in the **Game view**.
- The clicked point starts glowing gold, and the gold spreads outward with time.

![Midas Touch Working](https://github.com/user-attachments/assets/07ddfd55-9ab7-4a8c-b3bc-c43d61393c03)

---

## Behind the Scenes: How the Shader Reacts During Setup

- When you **click the swing**, the `ObjectDataSender` script sends two values to the shader:
  - `_ClickPos`: where the click happened (world position)
  - `_StartTime`: when the click happened (in seconds since start)
- The shader then checks these values:
  - Calculates how far each pixel is from the click
  - Determines whether the gold should have reached that pixel based on `_SpreadSpeed`
  - If yes, it blends that pixel’s color from the **base color** to a rich **gold color** (RGB = `1.0, 0.84, 0.0`)
  - It also adds specular and ambient light to make the gold shine!

---

## Future Improvements

Here are some features and upgrades planned to enhance this shader further:

### 1. Texture Integration
Allow support for main textures or normal maps so the gold spreads while preserving surface details like scratches or patterns.

### 2. Better Lighting Support
Enhance the shader to react to **baked lighting** or **light probes**

### 3. Masked Spread or Noise Variation
Use noise or patterns to create a more organic-looking spread instead of a perfect sphere.

### 4. Reverse the Effect
Allow toggling or reversing the spread (e.g., gold fades away).

### 5. Controller or VR Input Support
Expand interaction beyond mouse. Support for XR controllers, touch input, or even proximity triggers.

---

## Contributions Welcome!

If you’d like to fork this shader and add your own features, whether it’s improving performance, expanding compatibility to URP/HDRP, or creating beautiful gold ripple effects, go for it!
