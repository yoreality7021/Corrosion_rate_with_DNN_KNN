library(keras)
library(dplyr)
library(xgboost)
library(openxlsx)
#���Jrda��
{
# setwd("D:\\AI-work\\FCFC-ARO3\\R-code\\Rda")
path = getwd()
filenames = list.files(path=paste(path, sep =""), pattern="*.rda")

for (i in filenames){
  load(file=paste(path,"/", i, sep =""))
}
}
#���Jkeras��NN�w���ҫ�
kmodel = load_model_hdf5("keras-model.h5")

##�s�ƾڶi�Jkeras NN�w��-----
###����w���P��X���G###
{
# {  
# #�i�ۦ��J�ƭ�
# i1=as.numeric(readline("�п�J�J�ƶq�G"))
# i2=as.numeric(readline("�п�J�t���q�G"))
# i3=as.numeric(readline("�п�J�t��q�G"))
# i4=as.numeric(readline("�п�JC5+����G"))
# i5=as.numeric(readline("�п�JC4����G"))
# yu=data.frame(cbind(i1,i2,i3,i4,i5))
# colnames(yu)=c("x1","x2","x3","x4","x5")
# }
{
#���w�J�w�ƭ�
yu=data.frame(280,80,1,0.005,0.001)
colnames(yu)=c("x1","x2","x3","x4","x5")
}
#�N�s�ƾڥ��W��
yum=as.matrix(cbind(yux1maxmin(yu$x1),yux2maxmin(yu$x2),yux3maxmin(yu$x3),
                    yux4maxmin(yu$x4),yux5maxmin(yu$x5)))
#�i��w��(�t���q�PpH��)-----
yupred=data.frame(predict(kmodel,yum))
#�٭�w����(�ϥΰV�m��Ʈ榡)
reyu=data.frame(cbind(reyu1(yupred$X1),reyu2(yupred$X2)))
colnames(reyu)=c("H2O","PH")

##��J�ާ@�ū�(�ެq1 or 2 or 3/4)-----
netemp = matrix(c(68.2,55,44.3,44.3))
nempy = cbind(netemp,reyu$PH)
colnames(nempy)=c("Temp","PH")
#�ެq1~4���x�}���A
nempy1=matrix(nempy[1,1:2],ncol=2)
nempy2=matrix(nempy[2,1:2],ncol=2)
nempy3=matrix(nempy[3,1:2],ncol=2)
nempy4=matrix(nempy[4,1:2],ncol=2)
#�A�i�JAI model-2�i��xgboost�A�w���X�Ӻެq���G�k�v(beta)-----
beta1=data.frame(round(predict(xgb.model, nempy1),2))
names(beta1)=c("HCl")
beta2=data.frame(round(predict(xgb.model, nempy2),2))
names(beta2)=c("HCl")
beta3=data.frame(round(predict(xgb.model, nempy3),2))
names(beta3)=c("HCl")
beta4=data.frame(round(predict(xgb.model, nempy4),2))
names(beta4)=c("HCl")

#�U�ެq�ץ��Y��(alpha)-----
{
  s1alpha = round(s1(reyu[1,1]),5)
  s2alpha = round(s2(reyu[1,1]),5)
  s3alpha = round(s3(reyu[1,1]),5)
  s4alpha = round(s4(reyu[1,1]),5)
}
#�ץ���G�k�v-----
{
  fab1 = s1alpha * beta1
  fab2 = s2alpha * beta2
  fab3 = s3alpha * beta3
  fab4 = s4alpha * beta4
}
#��X���G-----
{
  cat(c("##Corrosion Prediction Result##\n",
        "Corrosion in PC1 = ", as.numeric(fab1),"\n",
        "Corrosion in PC2 = ", as.numeric(fab2),"\n",
        "Corrosion in PC3 = ", as.numeric(fab3),"\n",
        "Corrosion in PC4 = ", as.numeric(fab4),"\n"))
}

# fab5=data.frame(rbind(fab1,fab2,fab3,fab4))
# fab5=cbind(NA,fab5)
# colnames(fab5)=c("names","value")
# fab5[1:4,1]=c("PC1","PC2","PC3","PC4")
# 
# print(fab5)

}

###����w���P��X���G###