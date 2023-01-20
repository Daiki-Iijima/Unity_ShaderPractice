Shader "DShader/Edgebler"
{
  SubShader
  {
    Tags { 
      "Queue" = "Transparent" 
    }
    LOD 200

    CGPROGRAM
    // Physically based Standard lighting model, and enable shadows on all light types
    #pragma surface surf Standard alpha:fade

    // Use shader model 3.0 target, to get nicer looking lighting
    #pragma target 3.0

    struct Input
    {
      float3 worldNormal;
      float3 viewDir;
    };

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      o.Albedo = fixed4(1, 1, 1, 1);
      float cosTheta = dot(IN.viewDir, IN.worldNormal);
      cosTheta = pow(cosTheta,3);
      o.Alpha = cosTheta;
    }
    ENDCG
  }
  FallBack "Diffuse"
}