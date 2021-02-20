using MLDatasets
using Flux
using Flux: Data.DataLoader
using Flux: onehotbatch, onecold, crossentropy
using Flux: @epochs


struct TrainData
    x_train
    y_train
    x_validate
    y_validate
end


"""
Preprocess data (extract features) so it is ready for training
"""
function prepare_train_data()
    # Load datasets
    x_train, y_train = MNIST.traindata()
    x_test, y_test = MNIST.testdata()
    # Convert (28, 28, 60_000) shape into (28, 28, 1, 60_000)
    # This will add dimension for the channel
    x_train = Flux.unsqueeze(x_train, 3)
    # x_train = float(x_train) 
    x_test = Flux.unsqueeze(x_test, 3)
    # x_test = float(x_test)
    # The output will be 1-hot encoded
    y_train = onehotbatch(y_train, 0:9)
    y_test = onehotbatch(y_test, 0:9)
    TrainData(x_train, y_train, x_test, y_test)
end


function test_train_data(train_data::TrainData)
    @assert size(train_data.x_train) == (28, 28, 1, 60_000)
    @assert size(train_data.y_train) == (10, 60_000)
    @assert size(train_data.x_validate) == (28, 28, 1, 10_000)
    @assert size(train_data.y_validate) == (10, 10_000)
end


"""
Create Convolution network as a model
"""
function create_model()
    Chain(
        # 28x28x1 => 14x14x8 
        Conv((5, 5), 1=>8, pad=2, stride=2, relu),
        # 14x14x8 => 7x7x16 
        Conv((3, 3), 8=>16, pad=1, stride=2, relu),
        # 7x7x16 => 4x4x32
        Conv((3, 3), 16=>32, pad=1, stride=2, relu),
        # 4x4x32 => 2x2x32
        Conv((3, 3), 32=>32, pad=1, stride=2, relu),

        GlobalMeanPool(),
        flatten,

        Dense(32, 10),
        softmax
    )
end

"""Calculate prediction accuracy"""
accuracy(ŷ, y) = Flux.mean(onecold(ŷ) .== onecold(y))

function validate_prediction(model, x, y)
    # Getting predictions
    ŷ = model(x)
    # Decoding predictions
    score = accuracy(ŷ, y)
    println("Accuracy: $(score)")
end

"""Train model on the given dataset"""
function train_model!(model, train_data; num_epochs=10)
    # Create full dataset
    data = DataLoader(train_data.x_train, train_data.y_train, batchsize=128)

    loss(x, y) = crossentropy(model(x), y)
    lr = 0.1
    opt = Descent(lr)
    ps = Flux.params(model)
    @epochs num_epochs Flux.train!(loss, ps, data, opt)
end

function custom_training!(model, train_data, x_test, y_test; num_epochs=10)
    loss(x, y) = crossentropy(model(x), y)
    lr = 0.1
    opt = Descent(lr)
    ps = Flux.params(model)
    for epoch in 1:num_epochs
        for batch in train_data
            gradient = Flux.gradient(ps) do 
                training_loss = loss(batch...)  # `...` unpacking
                return training_loss
            end

            Flux.update!(opt, ps, gradient)
        end
        score = accuracy(model(x_test), y_test)
        println("Epoch: $epoch, accuracy: $score")
    end
end

train_data = prepare_train_data()
test_train_data(train_data)
model = create_model()
validate_prediction(model, train_data.x_validate, train_data.y_validate)
train_model!(model, train_data, num_epochs=1)
validate_prediction(model, train_data.x_validate, train_data.y_validate)