
Shader "Unlit/010"
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
                fixed3 worldNormal: TEXCOORD0;
                float3 worldPos: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                //转换为世界坐标系
                o.vertex = UnityObjectToClipPos(v.vertex);
                //将物体顶点法线转换为世界坐标系，并normalize
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                o.worldPos = UnityObjectToWorldDir(v.vertex);
                return o;
            }

            //SV_TARGET 返回颜色值，该值会输入到 RenderTarget中，RenderTarget帧缓存
            fixed4 frag(v2f i):SV_TARGET
            {
                //获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                //漫反射
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rbg * _Diffuse * max(0, dot(i.worldNormal, worldLight));

                //高光反射
                fixed3 reflectDir = normalize(reflect(-worldLight ,i.worldNormal));
                //视角方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 specular = _LightColor0.rbg * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss);


                fixed3 color = diffuse + ambient + specular;

                return fixed4(color,1);
            }

            ENDCG
        }
    }
}
