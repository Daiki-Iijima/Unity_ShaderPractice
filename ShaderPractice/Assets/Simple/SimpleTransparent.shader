Shader "DShader/Simple/SimpleTransparent"
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
      o.Albedo = fixed4(1.0f,1.0f,1.0f,1);
      //  ここで透過度を設定している
      o.Alpha = 0.6;
    }
    ENDCG
  }
  FallBack "Diffuse"
}