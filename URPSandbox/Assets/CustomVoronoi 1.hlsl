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

// Based on code by Inigo Quilez: https://iquilezles.org/articles/voronoilines/
void CustomVoronoi_float(float2 UV, float AngleOffset, float CellDensity, float CellValueModifier, out float DistFromCenter, out float DistFromEdge, out float CellValue)
{
    int2 cell = floor(UV * CellDensity);
    float2 posInCell = frac(UV * CellDensity);

    DistFromCenter = 8.0f;
    float2 closestOffset;

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
                closestOffset = cellOffset;
            }
        }
    }
    

    DistFromEdge = 8.0f;

    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            int2 cellToCheck = int2(x, y);
            float2 cellOffset = float2(cellToCheck) - posInCell + randomVector(cell + cellToCheck, AngleOffset);

            float distToEdge = dot(0.5f * (closestOffset + cellOffset), normalize(cellOffset - closestOffset));
            if (distToEdge < DistFromEdge) // If this cell is closer to the edge, update its value
            {
                DistFromEdge = distToEdge;
                //CellValue = lerp(hash(cell + cellToCheck), .5,.6); // Assign a unique value per Voronoi cell
                ///CellValue *= CustomPow(DistanceSquared((cell + cellToCheck),
                 //                       float2(0.5, 0.5), 2));
                                        
               /* CellValue = DistanceSquared((cell + cellToCheck),
                                        float2(CellDensity / 2, CellDensity / 2))/150;
                      */                  
                CellValue = DistanceSquared(cell,
                                        float2(CellDensity / 2, CellDensity / 2))/150;
                
            }
            DistFromEdge = min(DistFromEdge, distToEdge);
            
        }
    }
}
