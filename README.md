# kaggle-Classify-forest-types-MLOps
The goal of this repo is to create a basic deployment pipeline to put a neural model in Prod. The problem to solve is a classification problem we addressed in [1]. Please go to that repo to know more details of the problem. In this repo we are taking the neural network solution (simplified) described in experiment #15. It is not the goal of this repo to find the best solution to the problem but rather to create an automated infrastructure that can allow fast iteration and update of the model in Prod.

We are deploying the model in prod as an http api that can be called by any external party. To call the service just send a post request with a payload with the feature values that you have and it will return with a prediction. There are samples of using the api here [2]. The service is wrapped in a container that runs in a virtual machine. 

The perfomance of the model is quite good. Calling the probe endpoint (/) it takes just 9msec to the service to respond (calling from the same machine to eliminate variable network costs). When calling to the prediction api, latency ranges between 13-28 msecs. fastapi is lightweight and appropriate for this type of services.

Directories:\
**/api** Contains all the code and artifacts to build and run the model in Prod.\
/api/docker contains files to encapsulate the service in a container and scripts to build and test the container\
/api/src contains the code (python) of the service. We use fastapi[3] to build the service\
**/model/** contains all the code and artifacts to create and train the model.\
/model/docker contains files to encapsulate the code in a container and scripts to build and run the container\
/model/src contains the code (python) of the model. \
/model/src/model.py is a module that encapsulates the definition of the neural network and how to train it. We use keras [4] for modeling.\
/model/src/data.py is a module that encapsulates data engineering and validation.\
**/data** contains the data used for training the model. It is a copy of the train data in [1]. \
**/model-registry** is a place to store and retrieve the parameters of the model. used after training to save results and the service api access to it to set up the model in Prod. \
**/infra** is the place for all the infrastructure needed to have the model in Prod. At this time there is just a pipeline folder with a shell script to build and deploy the service.

I kept this repo quite simple to focus on building and deploying a neural model. I run it in a VM with just git and docker allowing me to iterate very fast: Modify code in my laptop - update the vm via git - rerun as needed. Using containers massively simplifies the environment. It also allows me to run only the parts I'm interesting on, not the whole system. To simplify the management of the VM I used these scripts [5]

Here are some ideas to sophisticate this service
1. use k8s instead of a VM. the containers can easily be converted to pods/services. I did a similar work for healthylinkx, the app that I use for most of my experiments, here [6]. You can also use Fargate (serverless k8s) an example here [8]
2. move data to an S3 bucket. If we want to run in a cluster or several instances we need to move the data outside the container/vm. S3 is a very effective way to do that
3. convert the model registry to an S3 bucket. For similar reasons than above. We can also add versioning so we keep history of the different models we built.
4. Use jenkins pipelines to build and release. Scripts are ok to experiment but jenkins is a more robust system with the support of a broad  community. I did some experimentation with jenkins (including running it on k8s) here [7]
5. Add loging (and store it somewhere). That will allow to add monitoring and alarms to the system.
6. Add performance testing (benchmarking). Compare the performance of the model (accuracy and latency mainly) with previous models and halt the release if not improving performance.

[1] https://github.com/mulargui/kaggle-Classify-forest-types \
[2] api/docker/test.sh \
[3] https://fastapi.tiangolo.com \
[4] https://keras.io/ \
[5] https://github.com/mulargui/DVM \
[6] https://github.com/mulargui/healthylinkx-k8s \
[7] https://github.com/mulargui/jenkins-pipeline \
[8] https://github.com/mulargui/healthylinkx-serverless-fargate 
