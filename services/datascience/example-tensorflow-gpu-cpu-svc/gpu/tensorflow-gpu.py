import tensorflow as tf
import pandas as pd
from matplotlib import pyplot as plt

#read data from csv
train_data = pd.read_csv("iris_training.csv", names=['f1', 'f2', 'f3', 'f4', 'f5'])
test_data = pd.read_csv("iris_test.csv", names=['f1', 'f2', 'f3', 'f4', 'f5'])

#encode results to onehot
train_data['f5'] = train_data['f5'].map({0: [1, 0, 0], 1: [0, 1, 0], 2: [0, 0, 1]})
test_data['f5'] = test_data['f5'].map({0: [1, 0, 0], 1: [0, 1, 0], 2: [0, 0, 1]})

#separate train data
train_x = train_data[['f1', 'f2', 'f3', 'f4']]
train_y = train_data.ix[:, 'f5']

#separate test data
test_x = test_data[['f1', 'f2', 'f3', 'f4']]
test_y = test_data.ix[:, 'f5']

#placeholders for inputs and outputs
X = tf.placeholder(tf.float32, [None, 4])
Y = tf.placeholder(tf.float32, [None, 3])

#weight and bias
weight = tf.Variable(tf.zeros([4, 3]))
bias = tf.Variable(tf.zeros([3]))

#output after going activation function
output = tf.nn.softmax(tf.matmul(X, weight) + bias)
#cost funciton
cost = tf.reduce_mean(tf.square(Y-output))
#train model
train = tf.train.AdamOptimizer(0.01).minimize(cost)

#check sucess and failures
success = tf.equal(tf.argmax(output, 1), tf.argmax(Y, 1))
#calculate accuracy
accuracy = tf.reduce_mean(tf.cast(success, tf.float32))*100

#initialize variables
init = tf.global_variables_initializer()

#start the tensorflow session
with tf.Session() as sess:
    costs = []
    sess.run(init)
    #train model 1000 times
    for i in range(1000):
        _,c = sess.run([train, cost], {X: train_x, Y: [t for t in train_y.as_matrix()]})
        costs.append(c)

    print("Training finished!")

    #plot cost graph
    plt.plot(range(1000), costs)
    plt.title("Cost Variation")
    plt.show()
    print("Accuracy: %.2f" %accuracy.eval({X: test_x, Y: [t for t in test_y.as_matrix()]}))
