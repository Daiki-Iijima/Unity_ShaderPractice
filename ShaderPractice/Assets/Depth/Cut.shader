Shader "Custom/Cut"
{
  SubShader
  {
    Tags { 
      "Queue"="Geometry-1"
      "ForceNoShadowCasting" = "True"
    }

    //  デプスバッファに書き込む
    Zwrite On
    //  描画チャネルを指定
    //  0はRGBすべてのチャネルを表示しない
    ColorMask 0

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0
    //  Shader Settings

    //  前の工程(Vertex)のシェーダーからの情報を受け取る
    struct Input
    {
      float2 uv_MainTex;
    };

    // あとの工程(Lighting)に出力する
    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      o.Albedo = fixed4(1.0f,1.0f,1.0f,1);
    }
    ENDCG
  }

  FallBack "Diffuse"
}
