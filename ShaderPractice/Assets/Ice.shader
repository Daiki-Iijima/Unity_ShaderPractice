Shader "DShader/Ice"
{
  SubShader
  {
    Tags { 
      "Queue" = "Transparent" 
    }
    LOD 200

    CGPROGRAM
    // Physically based Standard lighting model, and enable shadows on all light types
    #pragma surface surf Standard alpha:fade

    // Use shader model 3.0 target, to get nicer looking lighting
    #pragma target 3.0

    struct Input
    {
      float3 worldNormal;
      float3 viewDir;
    };

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      o.Albedo = fixed4(1, 1, 1, 1);
      float alpha = 1 - (abs(dot(IN.viewDir, o.Normal)));
      //float alpha = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
      o.Alpha =  alpha;
    }
    ENDCG
  }
  FallBack "Diffuse"
}