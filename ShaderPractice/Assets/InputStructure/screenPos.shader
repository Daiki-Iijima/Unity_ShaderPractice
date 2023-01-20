Shader "TestShader/screenPos"
{
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows

    #pragma target 3.0

    struct Input
    {
      float4 screenPos;
    };

    void surf(Input IN, inout SurfaceOutputStandard o) {
      o.Albedo = IN.screenPos;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
