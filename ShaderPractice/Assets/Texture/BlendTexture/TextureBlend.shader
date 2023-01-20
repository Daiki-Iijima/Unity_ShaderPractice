Shader "DShader/BlendTexture/TextureBlend"
{
  Properties
  {
    _MainTex ("メインテクスチャ", 2D) = "white" {}
    _SubTex ("サブテクスチャ", 2D) = "white" {}
    _MaskTex ("マスクテクスチャ", 2D) = "white" {}
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    // Physically based Standard lighting model, and enable shadows on all light types
    #pragma surface surf Standard fullforwardshadows

    // Use shader model 3.0 target, to get nicer looking lighting
    #pragma target 3.0

    sampler2D _MainTex;
    sampler2D _SubTex;
    sampler2D _MaskTex;

    struct Input
    {
      float2 uv_MainTex;
    };

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      //  各テクスチャの色をテクスチャ座標をもとに抽出
      fixed4 mainTex = tex2D (_MainTex, IN.uv_MainTex);
      fixed4 subTex = tex2D (_SubTex, IN.uv_MainTex);

      fixed2 uv = IN.uv_MainTex;
      //uv.x += _Time.y;
      fixed4 maskTex = tex2D (_MaskTex, uv);

      //  ブレンド
      fixed4 c = lerp(mainTex,subTex,maskTex);

      o.Albedo = c;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
