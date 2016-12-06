# sdk_tracking
# 基于sdk的追踪算法
# 基于SDM的目标跟踪实验报告


SDM（Supervised Descent Method)思想是由2013年CVPR的一篇文章提出的，这种方法主要是基于机器学习来解决复杂最小二乘问题(least squares problem)
。该方法思路很简洁，就是从训练数据中学习梯度下降的方向并建立相应的回归模型，然后利用得到的模型来进行梯度方向估计。


一般而言，所跟踪目标的当前一帧与下一帧的位置变化不会很大，因此，我们可以在下一帧中目标原来的位置处画多个位置框，通过计算重叠率，返回最大重
叠率的那个框来跟踪目标。这是基于线性回归的目标跟踪，但是很明显，这种方法跟踪效果不好，在此基础上，我们运用了层次回归以及SDM思想来跟踪目标
。
## 具体实现过程如下：
1. 采样样本，学习层次回归模型。
     在该试验中，我们共使用了三层回归学习，每一层我们学习[wx wy ro ]，其中，wx是dx与feats做线性回归后返回的系数，，wy是dy与feats做线性回归
     后返回的系数。在学到[wx wy]后，我们调节框的位置，然后计算与真实位置的重叠率overlap,再学习得到ro，其中ro为overlap与feats做线性回归后返
     回的系数，至此三个参数学习完毕，，并用其中的一个元胞存一下第一次学习到的结果，以便在预测目标位置的阶段使用。然后在此基础上再进行两层
     学习，并存下每次学习得到的结果，以便在预测目标位置时使用。
    注意，在此做线性回归时，使用的回归函数是linearregress(),而不是regress(),两者的区别在于损失函数的不同，前者原理是SVR（支持向量回
    归机），对噪声有比较好的鲁棒性。
2. 预测目标位置
   比如到第二帧图片时，我们预测的过程如下：在第一帧目标位置处随机撒很多粒子，利用在第一帧第一层学到的中心位置梯度更新框的位置，在此，我们
   利用第三个参数（重叠率）作为权重（weight），这样的过程进行三次，即进行三次层次回归，最后我们用一个函数dominantset()返回的是我们随机画
   的所有框的权重，然后我们利用这些框的加权求和可以得到一个最佳的目标框位置。
3. 更新回归模型
   回归模型的更新是从第二帧开始的，以后每预测完目标位置时都要进行更新，更新的过程类似于第一帧学习的过程，不同之处在于我们赋予新学到的
   参数R{i}new一个权重learnrate，得到的R{i}=learnrate*R{i}new+(1-learnrate)*R{i}。
