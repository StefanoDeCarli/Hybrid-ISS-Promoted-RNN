% Function to generate a name of the created network
function net_name = generate_net_name(is_lstm, num_layers, hidden_units, learn_rate)
    % Determine net type
    if is_lstm
        net_type = 'lstm';
    else
        net_type = 'gru';
    end

    % Fully connected layer info
    fc_str = sprintf('%d', hidden_units(1));

    % Number of layers string
    rnn_str = sprintf('%dL', num_layers);

    % Number of hidden units string
    hidden_units_str = sprintf('%d', hidden_units(2));
    for i = 2:num_layers
        hidden_units_str = sprintf('%s_%d', hidden_units_str, hidden_units(i+1));
    end

    % Learning rate string
    learn_rate_str = sprintf('%0.3f', learn_rate);

    % Construct the net_name
    net_name = sprintf('%s_%s_%s_%s_%s.mat', net_type, fc_str, rnn_str, hidden_units_str, learn_rate_str);
end