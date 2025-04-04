inline float3 randomVector(float3 UV, float offset)
{
    float3x3 m = float3x3(15.27, 47.63, 99.41, 89.98, 39.17, 43.55, 87,514,58.10);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float3(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5, sin(UV.z * +offset) * 0.5 + 0.5);
}
float hash(int3 p)
{
    return frac(sin(dot(float3(p), float3(127.1, 311.7, 631.8))) * 43758.5453);
}

float mod(float x, float y)
{
    return x - y * floor(x / y);
}

float DistanceSquared(float3 p1, float3 p2)
{
    return dot(p1 - p2, p1 - p2); // Returns squared distance
}

float CustomPow(float base, float exponent)
{
    return exp(exponent * log(base));
}



void CustomVoronoi_float(float3 WorldPos, float AngleOffset, float CellDensity, float CellValueModifier, float3 HolePosition,
                                        out float DistFromCenter,
                                        out float DistFromEdge,
                                        out float CellValue)
{
    int3 cell = floor(WorldPos * CellDensity);
    float3 posInCell = frac(WorldPos * CellDensity);

    DistFromCenter = 8.0f;
    float3 closestOffset;

    // --- First loop: find the nearest site and store it ---
    DistFromCenter = 999999.0f; // or some large number
    int3 nearestCell = int3(0, 0, 0);
    
    for (int z = -1; z <= 1; ++z)
    {
        for (int y = -1; y <= 1; ++y)
        {
            for (int x = -1; x <= 1; ++x)
            {
                int3 cellToCheck = int3(x, y, z);
                float3 cellOffset = float3(cellToCheck) - posInCell + randomVector(cell + cellToCheck, AngleOffset);

                float distToPoint = dot(cellOffset, cellOffset);

                if (distToPoint < DistFromCenter)
                {
                    DistFromCenter = distToPoint;
                    nearestCell = cellToCheck; // remember which cell is nearest
                    closestOffset = cellOffset;
                }
            }
        }
    }
    
    CellValue = DistanceSquared((cell + nearestCell) / CellDensity, HolePosition) * lerp(hash(cell + nearestCell), .5, .6); // ;

    DistFromEdge = 8.0f;
    for ( z = -1; z <= 1; ++z)
    {
        for (int y = -1; y <= 1; ++y)
        {
            for (int x = -1; x <= 1; ++x)
            {
                int3 cellToCheck = int3(x, y, z);
                float3 cellOffset = float3(cellToCheck) - posInCell + randomVector(cell + cellToCheck, AngleOffset);

                float distToEdge = dot(0.5f * (closestOffset + cellOffset), normalize(cellOffset - closestOffset));
                if (distToEdge < DistFromEdge) // If this cell is closer to the edge, update its value
                {
                    DistFromEdge = distToEdge;
                }
                DistFromEdge = min(DistFromEdge, distToEdge);
            
            }
        }
    }
}

void CustomVoronoi_half(float3 WorldPos, float AngleOffset, float CellDensity, float CellValueModifier, float3 HolePosition,
                        out float DistFromCenter,
                        out float DistFromEdge,
                        out float CellValue)
{
    CustomVoronoi_float(WorldPos, AngleOffset, CellDensity,
                        CellValueModifier, HolePosition,
                        DistFromCenter, DistFromEdge, CellValue);

}