Shader "TestShader/ViewDir"
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
      float3 viewDir;
    };

    void surf(Input IN, inout SurfaceOutputStandard o) {
      o.Albedo = float4(IN.viewDir.x,IN.viewDir.y,IN.viewDir.z,1);
    }
    ENDCG
  }
  FallBack "Diffuse"
}
