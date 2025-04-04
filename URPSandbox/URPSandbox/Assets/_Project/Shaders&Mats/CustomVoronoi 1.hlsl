inline float2 randomVector(float2 UV, float offset)
{
    float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
}
float hash(int2 p)
{
    return frac(sin(dot(float2(p), float2(127.1, 311.7))) * 43758.5453);
}

float mod(float x, float y)
{
    return x - y * floor(x / y);
}

float DistanceSquared(float2 p1, float2 p2)
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
    int2 cell = floor(WorldPos * CellDensity);
    float2 posInCell = frac(WorldPos * CellDensity);

    DistFromCenter = 8.0f;
    float2 closestOffset;

    // --- First loop: find the nearest site and store it ---
    DistFromCenter = 999999.0f; // or some large number
    int2 nearestCell = int2(0, 0);
    float2 nearestOffset = float2(0, 0);
    
    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            int2 cellToCheck = int2(x, y);
            float2 cellOffset = float2(cellToCheck) - posInCell + randomVector(cell + cellToCheck, AngleOffset);

            float distToPoint = dot(cellOffset, cellOffset);

            if (distToPoint < DistFromCenter)
            {
                DistFromCenter = distToPoint;
                nearestCell = cellToCheck; // remember which cell is nearest
                closestOffset = cellOffset;
            }
        }
    }
    
    CellValue = DistanceSquared((cell + nearestCell) / CellDensity,
                                float2(HolePosition.x, HolePosition.y)) * 4 * lerp(hash(cell + nearestCell), .5, .6);

    DistFromEdge = 8.0f;

    for (y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            int2 cellToCheck = int2(x, y);
            float2 cellOffset = float2(cellToCheck) - posInCell + randomVector(cell + cellToCheck, AngleOffset);

            float distToEdge = dot(0.5f * (closestOffset + cellOffset), normalize(cellOffset - closestOffset));
            if (distToEdge < DistFromEdge) // If this cell is closer to the edge, update its value
            {
                DistFromEdge = distToEdge;
            }
            DistFromEdge = min(DistFromEdge, distToEdge);
            
        }
    }
}


void CustomVoronoi_half(float3 WorldPos, float AngleOffset, float CellDensity, float CellValueModifier, float3 HolePosition, 
                        out float DistFromCenter, 
                        out float DistFromEdge, 
                        out float CellValue )
{
    CustomVoronoi_float(WorldPos, AngleOffset, CellDensity,
                        CellValueModifier, HolePosition,
                        DistFromCenter, DistFromEdge, CellValue);

}