
Shader "Unlit/009"
{
    Properties
    {
        //定义物体表面颜色
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
        //定义物体高光颜色
        _Specular("Specular", Color) = (1, 1, 1, 1)
        //
        _Gloss("Gloss",Range(1, 256) ) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //引用 Unity库
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 color: Color;   
            };

            //顶点漫反射
            v2f vert(appdata_base v)
            {
                v2f o;
                //转换为世界坐标系
                o.vertex = UnityObjectToClipPos(v.vertex);
                //获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //将物体顶点法线转换为世界坐标系，并normalize
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                //获取世界坐标系第一个直射光
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //计算出顶点对于直射光漫反射的角度
                fixed3 diffuse = _LightColor0.rbg * _Diffuse * saturate(dot(worldNormal, worldLight));

                fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - UnityObjectToWorldDir(v.vertex));
                fixed3 specular = _LightColor0.rbg * _Specular.rgb * pow(max(0, dot(reflectDir, viewDir)), _Gloss);
                o.color = specular + ambient + diffuse;
                return o;
            }

            //SV_TARGET 返回颜色值，该值会输入到 RenderTarget中，RenderTarget帧缓存
            fixed4 frag(v2f i):SV_TARGET
            {
                return fixed4(i.color,1);
            }

            ENDCG
        }
    }
}
