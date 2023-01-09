Shader "DShader/SimpleTransparent"
{
  SubShader {
    Tags { 
      // QueueをTransparent(透過)にする
      "Queue"="Transparent"
    }
    LOD 200

    CGPROGRAM
    //  fullforwrdを消してalpha:fadeを追加
    #pragma surface surf Standard alpha
    #pragma target 3.0

    struct Input {
      float2 uv_MainTex;
    };

    float4 _BaseColor;

    void surf (Input IN, inout SurfaceOutputStandard o) {
      o.Albedo = fixed4(0.6f,0.7f,0.4f,1);
      //  ここで透過度を設定している
      o.Alpha = 0.6;
    }
    ENDCG
  }
  FallBack "Diffuse"
}