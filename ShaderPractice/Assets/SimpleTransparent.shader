Shader "DShader/SimpleTransparent"
{
  //  Parameters
  Properties{
  }
  //  Parameters

  SubShader {
    //  Shader Settings
    Tags { 
      // RenderTypeをTransparent(透過)にする
      "RenderType"="Opaque"
    }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0
    //  Shader Settings

    //  前の工程(Vertex)のシェーダーからの情報を受け取る
    struct Input {
      float2 uv_MainTex;
    };

    //  SubShader内でPropertiesの項目を使用できるようにするには、内部でも宣言する必要がある
    float4 _BaseColor;

    // あとの工程(Lighting)に出力する
    void surf (Input IN, inout SurfaceOutputStandard o) {
      o.Albedo = _BaseColor.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}