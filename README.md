# UnityのShaderについてのメモ

## ツールバージョン

- UnityEditor : 2021.3.16f1

## マテリアル、シェーダー、テクスチャについて

- シェーダーとマテリアルは1対1で結びついている
- 同じシェーダーを別々のマテリアルが使用することもできる

```mermaid
graph

material1 --> Shader1
material2 --> Shader1
material3 --> Shader2
material4 --> Shader3
```

テクスチャについては、シェーダー内部で参照を持っているので、以下の図のような関係性になる。

- テクスチャを持たないShaderももちろん作成可能

```mermaid
graph

material1 --> Shader1 --> Texture

```

## Queueの描画順

奥から、

1. Background
2. Geometry
3. AlphaTest
4. Transparent
5. Overlay

![DrawOrder](./Images/QueueDrawOrder.png)

## Shaderの種類

![image](./Images/UnityCanCreateShaderList.png)

- Surface Shader
  - Unityの独自よりの、比較的簡単に記述できるシェーダー
  - 光源、影の付き方を考慮せずに書くことができる(メリット・デメリット)
  - 色、質感、テクスチャ周りを簡単に変更したいときに使う
- Unlit Shader
  - Shader界では、`Vertex`,`Fragment Shader`と呼ばれている
  - Unlit : Un Lighted, Un Illuminated
  - Vertex Shader : 頂点を制御するシェーダー
  - Fragment Shader : 最終的な出力を決定するシェーダー
  - 光源の影響を受けないシェーダー
  - Surface Shaderより、`光源や影`を考慮して実装する必要があるため、記述レベルは高い
- Image Effect Shader
  - ポストエフェクトなどに使用するシェーダー
- Compute Shader
  - GPUを使うことができるシェーダー
- Ray Tracing Shader

### 参考

Shader について

- [Shader の種類](http://neareal.com/2413/#vertexfragment)

## Surface Shader

頂点情報の変更や、光源、影の付け方についての記述はできない

具体的な処理の記述は、`surf関数`内に記述していきます。

- 具体的に表現すると、`SurfaceOutputStandard`が次の処理(lighting)への参照になるので、次の処理へ渡す値を設定している
  - o.Albedo : この`o`が次の処理への参照変数なので、その変数の`Albedo`というメンバ変数を変更することで結果が変わるということになる。

### SurfaceOutputStandardが持っている情報

```c#
struct SurfaceOutputStandardSpecular
{
    fixed3 Albedo;      // ディフューズ色
    fixed3 Specular;    // スペキュラー色
    fixed3 Normal;      // 書き込まれる場合は、接線空間法線
    half3 Emission;
    half Smoothness;    // 0=粗い, 1=滑らか
    half Occlusion;     // オクルージョン (デフォルト 1)
    fixed Alpha;        // 透明度のアルファ
};
```

### 色を決め打ちで設定しているShader

このシェーダーは、外部から設定できる情報は何もなく、決められた色を表現するしかできないシンプルなシェーダー

```c
Shader "DShader/Simple"
{
  //  Parameters
  //  Parameters
  SubShader
  {
    //  Shader Settings
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0
    //  Shader Settings

    //  Surface Shader
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
    //  Surface Shader

  }
  FallBack "Diffuse"
}
```

- Parameters
  - インスペクタに公開する変数を書く
- Shader Settings
  - ライティングや透明度などのシェーダの設定項目を記述
- Surface Shader
  - シェーダ本体のプログラム

Surface Shaderには、`入力`と`出力`がある

- 入力
  - `Input構造体`の中身が空ではコンパイルが通らない

  ```c#
  struct Input
  {
    float2 uv_MainTex;
  };
  ```

- 出力

  ```c#
  void surf (Input IN, inout SurfaceOutputStandard o)
  {
    o.Albedo = fixed4(1.0f,1.0f,1.0f,1);
  }
  ```

### 入力

- float3 viewDir - ビュー方向を含みます。視差効果、リムライティングなどの計算に使用されます。
- float4 with COLOR セマンティック - 補間された頂点ごとの色を含みます。
- float4 screenPos - 反射、または、スクリーンスペースエフェクトのためのスクリーンスペース位置を含みます。これは、GrabPass には適していないので注意してください。GrabPass のためにはComputeGrabScreenPos 関数でカスタム UV を算出する必要があります。
- float3 worldPos - ワールド空間の位置を含みます。
- float3 worldRefl - サーフェスシェーダーが o.Normal に書き込まない場合 のワールドの反射ベクトルを含みます。例については、反射―デフューズシェーダーを参照してください。
- float3 worldNormal - サーフェスシェーダーが o.Normal に書き込まない場合 のワールドの法線ベクトルを含みます。
- float3 worldRefl; INTERNAL_DATA - サーフェスシェーダーが o.Normal に書き込む場合 のワールドの反射ベクトルを含みます。ピクセル法線マップに基づいて反射ベクトルを取得するには、WorldReflectionVector (IN, o.Normal) を使用します。例については、反射-Bumped シェーダーを参照してください。
- float3 worldNormal; INTERNAL_DATA - サーフェスシェーダーが o.Normal に書き込む場合 のワールドの反射ベクトルを含みます。ピクセル法線マップに基づいて法線ベクトルを取得するには、WorldNormalVector (IN, o.Normal) を使用します。

### 外部からシェーダーのパラメーターを変更する

パラメーターを変更するには、2種類の方法があります。

1. Inspectorから手動で変更する
2. スクリプトからコードで変更する

#### 1. Inspectorから手動で変更する

Inspectorに表示する項目を`Parametersブロック`で定義する必要があります。

注意点として、`Parametersブロック`で定義した項目は、`Surfaceブロック`で更に同じ変数を定義しなければ`surfメソッド`内で使うことができないので注意が必要です。

```c#
Shader "DShader/SimpleTransparent"
{
  Properties{
    //  InspectorにBase Colorとして表示される
    _BaseColor("Base Color",Color) = (1,1,1,1)
  }

  SubShader {

    //  ....省略

    //  SubShader内でPropertiesの項目を使用できるようにするには、内部でも宣言する必要がある
    float4 _BaseColor;

    void surf (Input IN, inout SurfaceOutputStandard o) {
      //  色を適応
      o.Albedo = _BaseColor.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
```

#### 2. スクリプトからコードで変更する

Inspectorから設定しないのであれば、Propertiesブロックは不要で、Surfaceブロック内の定義のみで大丈夫です

- Shader

```c#
Shader "DShader/SimpleTransparent"
{
  Properties{
    //  InspectorにBase Colorとして表示される
    //  _BaseColor("Base Color",Color) = (1,1,1,1)
  }

  SubShader {
    //  ....省略

    //  外部からはSubShader内のメンバ変数にアクセスできる
    float4 _BaseColor;

    void surf (Input IN, inout SurfaceOutputStandard o) {
      //  色を適応
      o.Albedo = _BaseColor.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
```

- スクリプト

Rendererコンポーネントを取得し、マテリアル経由で対象のメンバ変数に対して値を設定します。

```c#
this.gameObject.GetComponent<Renderer>().material.SetColor("_BaseColor", Color.red);
```

## 透過させる

透過させるに注意するのは、

- 描画順
- 透過方法
- 透過度

になります。

### 描画順

`描画順`を考慮しないと、最終的な出力された絵がおかしなことになります。

- 描画順を考慮しなかった場合

  ```c#
  SubShader
  {
    Tags { 
       "Queue"="Background"
    }
    //  ...省略
  ```

   ![Background](./Images/Background.png)

- 描画順を考慮した場合

  ```c#
  SubShader
  {
    Tags { 
       "Queue"="Transparent"
    }
    //  ...省略
  ```

  ![Transparent](./Images/Transparent.png)

上の例は極端な表現ですが、描画順を考慮しない場合の絵は何か違和感があるのがわかるかと思います。

Shaderでは、描画順は、以下のように`"Queue"="XXX"`をTagに記述することでしていることができます。

```c#
SubShader
{
  //  タグの定義に追加します。
  //  描画時にUnity側が確認して描画処理を最適化してくれます。
  Tags { 
    "Queue"="XXX"
  }

  //  ...省略
```

### 透過方法

`透過方法`を指定する必要があります。

- シンプルな透過シェーダー

  ```c#
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
      #pragma surface surf Standard alpha:fade
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
  ```

## 視線座標とモデル法線の向きを使って輪郭に行くにつれてエフェクトをかける

Input構造体から取得できる情報として、以下の情報があります。

- worldNormal : 法線の向き
- viewDir :  カメラの向き

これらの値を使って、そのテクセルがモデル上のどの位置として表示されているのかを算出して、エッジを探します。その算出方法に使うのが、`内積`になります。

内積を使って、`モデルの法線の向き`と`カメラの向き`のベクトルがなす角度が何度(cosΘ)かがわかります。

- 内積を計算する場合は、ベクトルが正規化されている必要がありますが、今回使用するのは、法線と向きなので、すでに正規化されています。なのでそのままの値を使用できます。

```c#
float cosTheta = dot(法線の向き,カメラの向き)
```

dot積の答えは、`cosθ`になります。よって、2つのベクトルのなす角の違いによって以下の表の中のような値が取得できます。

![サインコサインタンジェント表](./Images/sine-cosine-tangent-table2.png)

cosΘは、2つのベクトルが作るなす角の角度が`狭ければ数値が大きく`、`角度が広ければ数値が小さく`なります。

```c#
角度 : 0° < 90°
cosΘ : 1.0  > 0.0
```

以上の特性から、cosΘの値が大きい場合は、オブジェクトの輪郭部分のテクセル、小さい場合は、内側にテクセルがあると判断できます。

以下はベクトルを可視化した図です。

![dotのイメージ](./Images/ドットのイメージ.png)

- 赤矢印 : viewDir
- 緑矢印 : worldNormal

この緑と赤のやじるのなす角を計算しているのが以下のコードです。

```c#
// ...
struct Input
{
  float3 worldNormal;
  float3 viewDir;
};

void surf (Input IN, inout SurfaceOutputStandard o)
{
  //  dot関数を使ってcosΘを求める
  float cosTheta = dot(IN.viewDir, o.Normal);
}
//  ...
```

### 輪郭を淡くする

先ほど計算したcosΘの値を透明度としてそのまま使用することで、輪郭に行く(cosΘが小さくなる)ほど、と透明度が上がるシェーダーが出来上がります。

```c#
Shader "DShader/Edgebler"
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
      float cosTheta = dot(IN.viewDir, IN.worldNormal);
      o.Alpha =  cosTheta;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
```

![エッジブラーシェーダー](./Images/%E3%82%A8%E3%83%83%E3%82%B8%E3%83%96%E3%83%A9%E3%83%BC%E3%82%B7%E3%82%A7%E3%83%BC%E3%83%80%E3%83%BC.png)

さらにエッジ側の透明度を上げて、輪郭をぼかしたい場合は、pow関数(累乗)を使って計算するといい感じになります。値の大きいほど変化が大きくなるので、グラデーションを強調したい時などに使えます。

```c#
//...
void surf (Input IN, inout SurfaceOutputStandard o)
{
  o.Albedo = fixed4(1, 1, 1, 1);
  float cosTheta = dot(IN.viewDir, IN.worldNormal);
  cosTheta = pow(cosTheta,3);
  o.Alpha =  cosTheta;
}
//...
```

![エッジブラーシェーダー強調版](./Images/%E3%82%A8%E3%83%83%E3%82%B8%E3%83%96%E3%83%A9%E3%83%BC%E3%82%B7%E3%82%A7%E3%83%BC%E3%83%80%E3%83%BC%E5%BC%B7%E8%AA%BF%E7%89%88.png)

### 輪郭を強調し、氷のような表現

エッジブラーシェーダーの逆バージョンをやるだけなので、`cosΘの結果を反転させるために、1からcosΘを引くコードを追加する`だけです。

```c#
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
      float cosTheta = dot(IN.viewDir, IN.worldNormal);
      o.Alpha =  cosTheta;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
```

![氷シェーダー](./Images/%E6%B0%B7%E3%82%B7%E3%82%A7%E3%83%BC%E3%83%80%E3%83%BC.png)

これも先ほどと同じで、濃淡をはっきりさせた方がきれいなので、`pow関数`を使うといいかと思います。

```c#
//  ...
void surf (Input IN, inout SurfaceOutputStandard o)
{
  o.Albedo = fixed4(1, 1, 1, 1);
  float cosTheta = dot(IN.viewDir, IN.worldNormal);
  cosTheta = pow(cosTheta,3); //  追加
  o.Alpha =  cosTheta;
}
//  ...
```

![氷シェーダー強調版](./Images/%E6%B0%B7%E3%82%B7%E3%82%A7%E3%83%BC%E3%83%80%E3%83%BC%E5%BC%B7%E8%AA%BF%E7%89%88.png)

### リムライティング

これも氷シェーダーと同じように`cosΘ`を使用することで表現できます。

この時に変更する値は、`Emission`になります。

```c#
Shader "DShader/RimLighting"
{
    SubShader
    {
        Tags { 
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float3 worldNormal;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = fixed4(1, 1, 1, 1);
            float cosTheta = 1 - dot(IN.viewDir, IN.worldNormal);
            cosTheta = pow(cosTheta,4);
            o.Emission = cosTheta;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
```

![リムライトシェーダー](./Images/%E3%83%AA%E3%83%A0%E3%83%A9%E3%82%A4%E3%83%88.png)

- 輪郭強調版

  ```c#
  //  ...
  void surf (Input IN, inout SurfaceOutputStandard o)
  {
    o.Albedo = fixed4(1, 1, 1, 1);
    float cosTheta = dot(IN.viewDir, IN.worldNormal);
    cosTheta = pow(cosTheta,4); //  追加
    o.Emission =  cosTheta;
  }
  //  ...
  ```

![リムライトシェーダー](./Images/%E3%83%AA%E3%83%A0%E3%83%A9%E3%82%A4%E3%83%88%E5%BC%B7%E8%AA%BF%E7%89%88.png)

## worldReflについて

worldReflはInput構造体で前のパイプラインから受け取っていますが、自前で実装することもできます。

以下のコードが自前で`worldRefl`を実装したものになります。

計算した結果を色として表現する場合は、Input構造体の中のworldReflと同じ色の表現にするには、計算した単位ベクトルworldReflを10倍する必要がありあました。

```c#
Shader "Test/ViewDirOriginalTest"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        struct Input {
            float3 worldNormal;
            float3 viewDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o) {

            float3 worldRefl = reflect(-IN.viewDir, IN.worldNormal);

            //  なぜか10倍する必要がある
            float r = worldRefl.x * 10;
            float g = worldRefl.y * 10;
            float b = worldRefl.z * 10;

            o.Albedo = float4(r,g,b,1);
        }

        ENDCG
    }
    FallBack "Diffuse"
}
```

## viewDirについて

Input構造体に入ってくるviewDirの値は、`shaderが当たったオブジェクトの各面`から見て、どの方向にカメラがあるかという値が入ってきます。(Dirなので単位ベクトル)

```c#
viewDir = (カメラワールド座標 - shaderが当たっているオブジェクトワールド座標).normalized
```

- 検証コード

  ```c#
  Shader "Test/ViewDirTest"
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


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //  viewDirの値と色を対応させてデバッグ
            //  (X,Y,Z) = (R,G,B)
            o.Albedo = float4(IN.viewDir,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
  }
  ```

ここで重要なのが、`どの方向`にというところで、`カメラ自体の角度`は関係ないことです。位置に対しての値なので、カメラが同じ位置から見る角度を変えても、`viewDir`の値は変化しません。

viewDirをAlbedoに直接代入した時の色の変化が下の画像になります。

- ()内の数字は、オブジェクトとカメラの中心位置からのviewDirです。モデルの端に行けば行くほど、値がゆっくり変化していきます。

![viewDir比較画像](./Images/viewDir%E3%81%AE%E6%AF%94%E8%BC%83%E7%94%BB%E5%83%8F.png)

- (R,G,B) = (X,Y,Z)の割り当てになっています。

- 赤い四角が原点(0,0,0)ですが、色の変化を見ても、原点位置から見ると一方こうにしか動いていないのに、色の変化が激しいことがわかります。このことからも、viewDirが`shaderが当たったオブジェクトの各面`からみての座標ということがわかるかと思います。

## 今後調べたい内容

- [ ] Input構造体の情報の変化について
- [ ] pragmaの意味と、surfの宣言について
  - [参考リンク(個人サイト)](https://unityshader.hatenablog.com/entry/2013/09/07/105000)
- [ ] alpha:fade 周りのまとめ
  - [参考リンク(Qiita)](https://qiita.com/keito_takaishi/items/a19b82d3d1395eaeaab9)
- [ ] shaderで`saturate()`と`abs`を使う意味
  - [Unity Shader で 0~ 1 の値を扱う際の雑メモ](https://kumak1.hatenablog.com/entry/2019/11/24/144115)
  - [リムライティング #8(記事の真ん中あたりに、saturate()の解説 + absとsaturate、結局カメラから裏見えないからどっちでも良い？)](https://soramamenatan.hatenablog.com/entry/2019/07/07/142908)

## メインで参考にしているサイト

- [7日間でマスターするUnityシェーダ入門](https://nn-hokuson.hatenablog.com/entry/2018/02/15/140037)
