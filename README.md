# Hybrid ISS-Promoted RNN
 Small Toolbox to aid ISS-promoted RNN architectures (LSTM and GRU) with a preprocessing fully connected layer.

## Folder Structure

The toolbox consists of the following main components:

1. `ISS_train.m`: The primary function for training the ISS-promoted RNN.
2. `utilities`: A folder containing utility functions required for the training process.
3. `monitor_data_viewer.m`: A script for visualizing the training progress and ISS metrics.
4. `tester.m`: A script to test the functionality of the training process using a provided dataset.
5. `data`: Contains the dataset for testing and validation purposes.
6. `README.md`: This file provides an overview and instructions for using the toolbox.

## ISS_train.m

This function trains an ISS-promoted network, either LSTM or GRU (RNN), with a preprocessing fully connected (FC) layer and returns the trained network, training information, monitor data, and the network name. The network is trained to achieve the minimum validation RMSE while promoting ISS.

### Function Signature

```matlab
function [net, info, monitor, net_name] = ISS_train(train_dataset, valid_dataset, ...
    is_lstm, hidden_units, dropout_rate, ...
    u_max_inputs, learn_rate, max_epochs, mini_batch, varargin)
```

### Parameters

-   `train_dataset`: Structured dataset for training, with `x` and `y` as trials, already normalized.
-   `valid_dataset`: Structured dataset for validation, with `x` and `y` as trials, already normalized.
-   `is_lstm`: Boolean flag to select LSTM (`true`) or GRU (`false`) architecture.
-   `hidden_units`: Array specifying the number of hidden units in each layer, from the FC to the N RNN ones.
-   `dropout_rate`: Dropout rate for the network.
-   `learn_rate`: Learning rate for training.
-   `max_epochs`: Maximum number of epochs for training.
-   `mini_batch`: Number of trials used in training for each iteration.
-   `varargin`: Optional parameter specifying the penalty for ISS in the loss function. Default is 0.05.

### Example Usage

```matlab
data = load(fullfile('data', 'SMI_data.mat'));
varName = fieldnames(data);   % Get the field name(s) in the structure
data = data.(varName{1});     % Access the contents using dynamic field referencing

train_dataset = data.train_30s;
valid_dataset = data.validation_30s;

train_dataset.x = transpose_cell(train_dataset.x);
train_dataset.y = transpose_cell(train_dataset.y);

valid_dataset.x = transpose_cell(valid_dataset.x);
valid_dataset.y = transpose_cell(valid_dataset.y);

is_lstm = true;
hidden_units = [256; 256; 128; 64; 32];
dropout_rate = 0.2;
learn_rate = 0.0035;
max_epochs = 1000;
mini_batch = 10;

[net, info, monitor, net_name] = ISS_train(train_dataset, valid_dataset, ...
    is_lstm, hidden_units, dropout_rate, ...
    u_max_inputs, learn_rate, max_epochs, mini_batch, 0.3);
```

Note: `transpose_cell(...)` is not required if a proper dataset is used, formatted as below.

### Dataset Structure

The dataset should be a struct with the following fields:

-   `description`: Description of the dataset.
-   `x`: Cell array of input data, each cell containing a matrix of size `[N_steps x N_inputs]`.
-   `y`: Cell array of output data, each cell containing a matrix of size `[N_steps x N_outputs]`.
-   `x_mean`, `y_mean`, `x_std`, `y_std`: Optional fields for normalization statistics.

Example structure:

```matlab
dataset = struct(...
    'description', "General structure to store a dataset", ...
    'x', [], ...
    'y', [], ...
    'x_mean', [], ...
    'y_mean', [], ...
    'x_std', [], ...
    'y_std', [] ...
);
```

utilities
-------------

This folder contains utility functions required for the training process. Ensure that this folder is included in your MATLAB path.

monitor_data_viewer.m
---------------------

This script visualizes the training progress and ISS metrics. It loads the monitor data from a saved network results file and generates plots for RMSE and ISS metrics.

tester.m
--------

This script tests the functionality of the training process using the provided dataset `SMI_data.mat`. It demonstrates the ISS-promoted training.

Theory: strict Input-to-State Stability (ISS)
--------------------------------------

Strict Input-to-State Stability (ISS) is a desirable property in dynamic systems that ensures the system's state remains bounded in response to bounded inputs. This is crucial for ensuring realistic and stable behavior in RNNs, especially when modeling physical systems.

### Implementation in RNNs

To promote ISS in RNNs, we incorporate stability constraints into the training process. This involves:

-   **Custom Loss Function**: Adding a penalty term to the loss function that favors ISS.
-   **Regularization**: Using techniques like dropout and weight regularization to prevent overfitting and ensure stable learning.
-   **Architecture Design**: Carefully designing the network architecture, including the number of hidden units and layers, to balance complexity and stability.

Getting Started
---------------

1.  Clone or download the repository to your local machine. 
2.  Run the `tester.m` script to train a sample network and save the results.
3.  Use the `monitor_data_viewer.m` script to visualize the training progress and ISS metrics.
4.  Do whatever you want with the file :blush:

License
-------

This project is licensed under the MIT License. See the LICENSE file for more details.

Happy training with the hybrid ISS-Promoted RNN Toolbox!
