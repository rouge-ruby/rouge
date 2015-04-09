#version 330 core

/**
 * The Material structure stores the details about the material
 */
struct Material
{
    vec4 ambientColor;
    vec4 diffuseColor;
    vec4 specularColor;

    float dissolve;
    float specularPower;
    float illumination;
};

// The light structure
struct Light
{
    vec3 direction;
    vec4 color;
    float intensity;
};

uniform mat4 mTransform;
uniform mat4 camProj;
uniform mat4 camView;

uniform sampler2D textureID;
uniform Material material;
uniform Light light;

in vec4 vColor;
in vec4 vNormal;
in vec4 vPosition;
in vec2 vTexCoords;

layout(location = 0) out vec4 fragColor;

vec4 getBaseColor()
{
    // Create the texture color
    vec4 texColor = texture(textureID, vTexCoords);

    return vec4(min(texColor.rgb + vColor.rgb, vec3(1.0)), texColor.a * vColor.a);
}

vec4 getDirectionalLight()
{
    // The matrices for transforming into different spaces
    mat4 modelMatrix = mTransform;
    mat3 normalMatrix = transpose(inverse(mat3(modelMatrix)));

    // The transformed normal and position
    vec3 normal = normalMatrix * vNormal.xyz;
    vec3 position = vec3(modelMatrix * vPosition);

    // The individual components of light
    vec4 ambientLight = vec4(0.0);
    vec4 diffuseLight = vec4(0.0);
    vec4 specularLight = vec4(0.0);

    // Calculate the ambient light
    ambientLight = light.color * material.ambientColor;

    // Calculate the diffuse light
    float diffuseFactor = dot(normalize(normal), -light.direction);

    if (diffuseFactor > 0.0)
    {
        diffuseLight = light.color * material.diffuseColor * diffuseFactor;

        // Calculate the specular light
        vec3 vertexToEye = normalize(vPosition.xyz - position);
        vec3 lightReflect = normalize(reflect(light.direction, normal));

        float specularFactor = dot(vertexToEye, lightReflect);
        specularFactor = pow(specularFactor, material.specularPower);

        if (specularFactor > 0)
            specularLight = light.color * specularFactor;
    }

    // Calculate the final directional light
    return (ambientLight + diffuseLight + specularLight) * light.intensity;
}

void main()
{
    fragColor = getBaseColor() * getDirectionalLight();
}
