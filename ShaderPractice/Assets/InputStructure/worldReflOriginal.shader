Shader "TestShader/WorldReflOriginal"
{
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard 
    //  ライト系の処理を行いたい場合は必要
    //  何も指定していない場合は、fullforwardshadowsが使用されるので、消しても大丈夫
    //#pragma fullforwardshadows

    #pragma target 3.0

    struct Input {
      float3 worldNormal;
      float3 viewDir;
    };

    UNITY_INSTANCING_BUFFER_START(Props)
    UNITY_INSTANCING_BUFFER_END(Props)

    void surf (Input IN, inout SurfaceOutputStandard o) {

      float3 worldRefl = reflect(-IN.viewDir, IN.worldNormal);
      //  viewDirの値と色を対応させてデバッグ
      //  (X,Y,Z) = (R,G,B)
      float r = worldRefl.x * 10;
      float g = worldRefl.y * 10;
      float b = worldRefl.z * 10;

      o.Albedo = float4(r,g,b,1);
    }

    ENDCG
  }
  FallBack "Diffuse"
}