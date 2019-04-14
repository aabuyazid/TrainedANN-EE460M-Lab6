# TrainedANN-EE460M-Lab6


# Lab Assignment 6

## Part A

Matrix multiplication using Systolic Arrays

(You are allowed to work in groups of 2 for this Lab)

## Objective

To perform matrix multiplication using Systolic Array structures.

## Description

A systolic array is a network of processors that rhythmically compute and pass data through the
system.

Figure

Data item is not only used when it is input but also reused as it moved through the pipelines in
the array.

## Design

In this lab, you are required to implement a 3 X 3 Matrix multiplier using systolic array structure
built with MAC (Multiple and Accumulate) units.

The MAC operation modifies an accumulator register A with the below operation

```
A<-(A+B*C)
```
You are expected to use a specific floating point number representation to implement the MAC
unit. Each matrix element should be of 8 - bit width.

The 8 - bit representation should occupy **1 bit for the sign, 3 bits for the exponent and 4 bits for
the mantissa (fraction) parts with a leading 1**. Floating point number representation is
described in Chapter 7 of the textbook. You are advised to read through the section before
starting with this lab.

The matrix multiplier operation is illustrated in the Figure 2.


Figure 2

To multiply two 3 X 3 matrices, there are 33 multiplications that need to be performed. It is
possible to use N^2 MAC units enabling completion of the matrix multiplication in N steps. For
example, consider the fabric with 9 MACs as shown in Figure 2. In order to multiply the two 3 X
3 matrices, the matrix elements are staged as shown in the figure. Figure 2 (a) indicates the
condition at time 1. In the first cycle, a0,0 and b0,0 propagate into the top left MAC and get


multiplied. In the next cycle, a0,0 moves to the right and b0,0 moves to the bottom direction. Two
more MACs are involved in cycle 2. Figure 2 (b) indicates the location of the operands in the 3rd
cycle. In the 7th cycle, all multiplications and additions are completed, and each of the answers
are residing in the N MACs. Please note that your outputs signals are also expected to be of 8 -
bit width. Please take care of this truncation operation in your design.

### Submission Details

- Verilog files of all modules
- Test bench in Verilog
- We expect a structural modeling of MAC unit (using for loops for matrix multiplication is
    not allowed).

### Checkout Details

You are expected to only simulate the Matrix Multiplier structure in Vivado/Modelsim.


## Part B

### Objective

To perform FPGA implementation of a Trained Feedforward Artificial Neural Network (ANN)
core.

### Description

Artificial Neural Networks (ANN) are non-linear statistical data modeling tools, often used to
model complex relationships between inputs and outputs or to find patterns in data. An
artificial neuron forms the basic unit of artificial neural networks. The basic elements of an
artificial neuron are:

(1) a set of input nodes, indexed by, say, 1, 2, ... i, that receives the corresponding input signal
or pattern vector, say x = (x1, x2...xi)

(2) a set of synaptic connections whose strengths are represented by a set of weights, here
denoted by w = (w1, w2...wi)

(3) an activation function Φ that relates the total synaptic input to the output (activation) of the
neuron

(4) Bias value (typically a constant value of 1)

The main components of an artificial neuron are illustrated in the below figure.


The total synaptic input, V, to the neuron is given by the inner product of the input and weight
vectors:

```
V=X 1 W 1 +X 2 W 2 +X 3 W 3 .....XnWn+Bias*Weightbias
```
where we assume that the threshold of the activation is incorporated in the weight vector. The
output activation is given by

```
Output=F(V)
```
where F denotes the activation function of the neuron.

Consequently, the computation of the inner-products is one of the most important arithmetic
operations to be carried out for a hardware implementation of a neural network. This means
not just the individual multiplications and additions, but also the alternation of successive
multiplications and additions — in other words, a sequence of multiply-add (also commonly
known as multiply-accumulate or MAC) operations.

**Multi-layer perceptron**

The multi-layer perceptron (MLP) is a feedforward neural network consisting of an input layer
of nodes, followed by two or more layers of perceptrons, the last of which is the output layer.
The layers between the input layer and output layer are referred to as hidden layers. Illustrated
below is the diagram of a 2- 2 - 1 neural network (2 inputs, 2 hidden layers and 1 output).

The dotted circle shows the bias value of 1 (typically a constant value of 1), which is also added
along with the inner product of its weights at every neuron.

### Design

1. **Data Representation**


Before beginning a hardware implementation of an ANN, a number format (fixed, floating point
etc.) must be considered for the inputs, weights and activation function. In this lab, you are
required to use **8 - bit floating point data** for the signals.

The representation should occupy **1 bit for the sign, 3 bits for the exponent and 4 bits for the
mantissa parts with a leading 1**. Floating point number representation is described in Chapter 7
of the textbook. You are advised to read through the section before starting with this lab.

2. **Neuron Architecture**

Basic block diagram for a neuron architecture is shown below:

1. Weights for a Trained neural network will be provided to you. You are expected to store
    the contents in a ROM and index the contents using the corresponding address values.
2. Bias value will also be provided to you along with the weight. You are also expected to
    store these values in the ROM to be addressed later for calculations. Bias value will be
    loaded with **load** signal
3. The MAC unit receives the inputs/bias values/weights and should perform Multiplication
    and accumulation. MAC unit is expected to perform floating point arithmetic. The
    **out_enable** signal triggers the neuron to the next layer after passing through the
    activation function.
**3. Activation Function implementation**

In this lab, we expect you to implement a **piecewise linear interpolation function** for
approximating a more accurate activation function (sigmoid function).


The function is defined by **f(x)=c1+c2*x** , where c1 and c2 are constants and x is the output
signal from the MAC unit.

**4. Network Architecture**

In this lab, you are expected to design a 3- 5 - 1 Neural Network Architecture. This means that
there are 3 input signals, 5 neurons in the hidden layer and one output signal.

Please find the Block Diagram of a 3- 5 - 1 Neural Network Architecture.

First it activates the load signals of the neurons and the neurons load their bias values. Then the
hidden layer is enabled for 3 clock cycles, and then the output layer consisting of a single
neuron is enabled for 5 clock cycles. Out_enable signals are also activated by this state machine
for each of the layers and neurons.

**Sample Input signals, the corresponding weights and the constants in activation function to
be used for demonstration:**

x1- 1 , w1-0.5, w2-0.25, w3-0.75, w4-0.5, w5-0.

x2- 0 , w6-0.25, w7-0.5, w8-0.25, w9-0.75, w10-0.

x3- 1 , w11-0.75, w12-0.75, w13-0.5, w14-0.5, w15-0.

Weights for hidden layers

h1: w16- 0.

h2: w17- 0.

h3: w18- 0.


h4: w19- 0.

h5: w20- 0.

Bias value for hidden layer – 1 , Weight for bias - - 0.

Bias value for output layer – 0.5, Weight for bias - 0. 5

c1 (constant1 in approximated activation function) - 0.

c2 (constant 2 in approximated activation function) - 0.

Activation function f(x)=c1+c2*x

### Submission Details

- Verilog files of all modules
- Utilization reports


### Checkout Details

The advantage of implementing neural networks on FPGA is typically the speed of operation.
On a general-purpose microprocessor, it might take hundreds of cycles to execute the neural
net core. Your grading for this lab will be based on the speed of operation of the neural
network structure, along with correct output prediction. **Please note that we will check the
design using different input signals during checkout**.

You will be expected to demonstrate the below 2 parameters during checkout:

1. Correct output bits for input data and given weights
2. Number of cycles within which output is generated.

Generate a 1Hz clock of period 1s to demonstrate the lab outputs during checkout. Use the
below mapping to demonstrate the outputs:

**SW0** - x

**SW1** - x

**SW2** - x

**LED15** - OUT[7]

**LED14** - OUT[6]

**LED13** - OUT[5]

**LED12** - OUT[4]

**LED11** - OUT[3]

**LED10** - OUT[2]

**LED9** - OUT[1]

**LED8** - OUT[0]

**LED 0** - CLK of 1Hz frequency


