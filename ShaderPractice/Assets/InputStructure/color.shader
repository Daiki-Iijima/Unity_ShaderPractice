Shader "TestShader/color"
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
      float4 color;
    };

    void surf(Input IN, inout SurfaceOutputStandard o) {
      o.Albedo = IN.color;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
