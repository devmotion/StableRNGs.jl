using StableRNGs, Test
using Random

@testset "initialization" begin
    @test StableRNG === LehmerRNG
    @test_throws MethodError LehmerRNG()
    rng = LehmerRNG(0)
    @test_throws MethodError Random.seed!(rng)
    @test_throws ArgumentError LehmerRNG(rand(typemin(Int):-1))
    @test_throws ArgumentError Random.seed!(rng, rand(typemin(Int):-1))

    for seed in Int64[0, 1, 2, 3, 4, typemax(Int32),
                      Int64(2)^32, typemax(Int64)]
        for T = (Int32, Int64)
            seed > typemax(T) && continue
            seed = T(seed)
            rng = LehmerRNG(seed)
            @test rng isa LehmerRNG
            @test isodd(rng.state)
            state = rng.state
            rng2 = Random.seed!(rng, seed)
            @test rng2 === rng
            @test isodd(rng.state)
            if !isempty(seed)
                @test rng.state == state
            end
        end
    end
end
