#pragma warning disable 649
using TriLibCore.General;
using UnityEngine;
using TriLibCore.Extensions;
using UnityEngine.UI;
using UnityEngine.Rendering;

namespace TriLibCore.Samples
{
    /// <summary>
    /// Represents a sample that loads a Model from a file-picker.
    /// </summary>
    public class LoadModelFromFilePickerSample : MonoBehaviour
    {
        /// <summary>
        /// The last loaded GameObject.
        /// </summary>
        private GameObject _loadedGameObject;

        /// <summary>
        /// The load Model Button.
        /// </summary>
        [SerializeField]
        private Button _loadModelButton;

        /// <summary>
        /// The progress indicator Text;
        /// </summary>
        [SerializeField]
        private Text _progressText;

        /// <summary>
        /// Creates the AssetLoaderOptions instance and displays the Model file-picker.
        /// </summary>
        /// <remarks>
        /// You can create the AssetLoaderOptions by right clicking on the Assets Explorer and selecting "TriLib->Create->AssetLoaderOptions->Pre-Built AssetLoaderOptions".
        /// </remarks>
        public void LoadModel()
        {
            var assetLoaderOptions = AssetLoader.CreateDefaultLoaderOptions();
            assetLoaderOptions.AddSecondAlphaMaterial = false;
            assetLoaderOptions.UseAlphaMaterials = true;
            assetLoaderOptions.LoadTexturesAsSRGB = false;
            var assetLoaderFilePicker = AssetLoaderFilePicker.Create();
            assetLoaderFilePicker.LoadModelFromFilePickerAsync("Select a Model file", OnLoad, OnMaterialsLoad, OnProgress, OnBeginLoad, OnError, null, assetLoaderOptions);
        }

        /// <summary>
        /// Called when the the Model begins to load.
        /// </summary>
        /// <param name="filesSelected">Indicates if any file has been selected.</param>
        private void OnBeginLoad(bool filesSelected)
        {
            _loadModelButton.interactable = !filesSelected;
            _progressText.enabled = filesSelected;
        }

        /// <summary>
        /// Called when any error occurs.
        /// </summary>
        /// <param name="obj">The contextualized error, containing the original exception and the context passed to the method where the error was thrown.</param>
        private void OnError(IContextualizedError obj)
        {
            Debug.LogError($"An error occurred while loading your Model: {obj.GetInnerException()}");
        }

        /// <summary>
        /// Called when the Model loading progress changes.
        /// </summary>
        /// <param name="assetLoaderContext">The context used to load the Model.</param>
        /// <param name="progress">The loading progress.</param>
        private void OnProgress(AssetLoaderContext assetLoaderContext, float progress)
        {
            _progressText.text = $"Progress: {progress:P}";
        }

        /// <summary>
        /// Called when the Model (including Textures and Materials) has been fully loaded.
        /// </summary>
        /// <remarks>The loaded GameObject is available on the assetLoaderContext.RootGameObject field.</remarks>
        /// <param name="assetLoaderContext">The context used to load the Model.</param>
        private void OnMaterialsLoad(AssetLoaderContext assetLoaderContext)
        {
            // ref: https://forum.unity.com/threads/trilib-model-loading-package.478480/page-31
            foreach (var kvp in assetLoaderContext.LoadedMaterials)
            {
                Material mat = kvp.Value;

                mat.EnableKeyword("_EMISSION");

                float matR = mat.color[0];
                float matG = mat.color[1];
                float matB = mat.color[2];
                float matA = mat.color[3];

                matR = Mathf.Pow(matR, 1/2.2f);
                matG = Mathf.Pow(matG, 1/2.2f);
                matB = Mathf.Pow(matB, 1/2.2f);

                mat.color = new Color(matR, matG, matB, matA);
                
                Texture2D tex2d;
                Texture tex = mat.GetTexture("_BaseMap");
                if (tex != null) {
                    if (tex.dimension == TextureDimension.Tex2D) {
                        tex2d = ToTexture2D(tex);
                        
                        for (int y = 0; y < tex2d.height; y++) {
                            for (int x = 0; x < tex2d.width; x++) {
                                Color pixel = tex2d.GetPixel(x, y);

                                float texR = pixel[0];
                                float texG = pixel[1];
                                float texB = pixel[2];
                                float texA = pixel[3];

                                texR = Mathf.Pow(texR, 1/2.2f);
                                texG = Mathf.Pow(texG, 1/2.2f);
                                texB = Mathf.Pow(texB, 1/2.2f);

                                tex2d.SetPixel(x, y, new Color(texR, texG, texB, texA));
                                
                            }
                        }

                        mat.SetTexture("_BaseMap", tex2d);
                        tex2d.Apply();
                    }
                }

                if (assetLoaderContext.RootGameObject != null)
                {
                    Debug.Log("Model fully loaded.");
                }
                else
                {
                    Debug.Log("Model could not be loaded.");
                }
                _loadModelButton.interactable = true;
                _progressText.enabled = false;
            }
        }

        /// <summary>
        /// Called when the Model Meshes and hierarchy are loaded.
        /// </summary>
        /// <remarks>The loaded GameObject is available on the assetLoaderContext.RootGameObject field.</remarks>
        /// <param name="assetLoaderContext">The context used to load the Model.</param>
        private void OnLoad(AssetLoaderContext assetLoaderContext)
        {
            if (_loadedGameObject != null)
            {
                Destroy(_loadedGameObject);
            }
            _loadedGameObject = assetLoaderContext.RootGameObject;
            if (_loadedGameObject != null)
            {
                Camera.main.FitToBounds(assetLoaderContext.RootGameObject, 2f);
            }
        }

        private Texture2D ToTexture2D(Texture tex)
        {
            var sw = tex.width;
            var sh = tex.height;
            var format = UnityEngine.TextureFormat.RGBA32;
            var result = new Texture2D(sw, sh, format, false);
            var currentRT = RenderTexture.active;
            var rt = new RenderTexture(sw, sh, 32);
            Graphics.Blit(tex, rt);
            RenderTexture.active = rt;
            var source = new Rect(0, 0, rt.width, rt.height);
            result.ReadPixels(source, 0, 0);
            result.Apply();
            RenderTexture.active = currentRT;
            return result;
        }
    }
}
