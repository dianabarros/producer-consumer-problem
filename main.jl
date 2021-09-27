using Distributed

addprocs(1)

const products = RemoteChannel(() -> Channel{Int}(32))

@everywhere function produce(products, n)
    for _ in 1:n
        product = rand(1:10)
        sleep(product)
        println("produced ", product)
        put!(products, product)
    end
end

function consume(products, n)
    produced = 0
    while produced < n
        product = take!(products)
        println("Consumed product number ", product)
        produced += 1
    end
end

println("start producer")
remote_do(produce, 2, products, 10)

println("now consume")
consume(products, 10)