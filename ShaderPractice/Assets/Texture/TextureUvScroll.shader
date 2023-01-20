Shader "DShader/TextureUvScroll"
{
    Properties
    {
        _MainTex ("テクスチャ", 2D) = "white" {}
        _XScrollSpeed("スクロールスピードX",float) = 1
        _YScrollSpeed("スクロールスピードY",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float _XScrollSpeed;
        float _YScrollSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;

            // 経過時間分uvを移動させる
            uv.x += _XScrollSpeed * _Time.y;
            uv.y += _YScrollSpeed * _Time.y;

            fixed4 c = tex2D (_MainTex, uv);
            o.Albedo = c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
