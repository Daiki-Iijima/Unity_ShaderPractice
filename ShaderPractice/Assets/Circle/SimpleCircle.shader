Shader "DShader/Circle/SimpleCircle"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    sampler2D _MainTex;

    struct Input
    {
      float2 uv_MainTex;
      float3 worldPos;
    };

    half _Glossiness;
    half _Metallic;
    fixed4 _Color;

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      float dist = distance(fixed3(0,0,0),IN.worldPos);
      if(dist > 1){
        o.Albedo = float4(1,0,0,1);
        }else{
        o.Albedo = float4(1,1,1,1);
      }
    }
    ENDCG
  }
  FallBack "Diffuse"
}
