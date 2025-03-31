<a name="zQm9B"></a>
## 查询python环境
![](https://cdn.nlark.com/yuque/0/2024/png/39147835/1725275864299-eba82084-f002-4a22-9931-b538da566e15.png#averageHue=%23424242&clientId=u58c5e0a0-b092-4&from=paste&id=u0b0128df&originHeight=147&originWidth=980&originalType=url&ratio=1.9199999570846558&rotation=0&showTitle=false&status=done&style=none&taskId=u8d3bc975-433d-4ece-b810-0bf1d47954e&title=)
> conda --version
> python --version

<a name="CjsfD"></a>
## 环境处理
创建环境
> conda create -n tensorflow-gpu python=3.11.5（上面查到的版本)

查询环境
> conda info _--envs_

激活环境
> activate tensorflow-gpu

关闭当前环境
> conda deactivate

删除环境
> conda env remove --name your_env_name

<a name="a5t9H"></a>
## 下载transform
<a name="IAGHP"></a>
### 方式一：pip 下载
> pip --default-timeout=100 install tensorflow
> 或者 pip install tensorflow

检查安装成功
> conda search--full --name tensorflow

<a name="fv5jk"></a>
### 方式二：conda下载
> conda create --name tensorflow1 python=3.11.5 anaconda
> conda activate tensorflow1
> pip --default-timeout=100 install tensorflow
> conda list tensorflow

<a name="eJazT"></a>
## 安装keras框架
<a name="XEj9Z"></a>
### cpu版本
> pip install keras

<a name="Fym0U"></a>
### gpu版本
> pip install keras-gpu  //(版本较老，transform 已支持，可以跳过)

<a name="FiiCc"></a>
## 在jupyter中添加内核
> activate tensorflow-gpu
> conda isntall ipykernel
> python -m ipykernel install --name tensorflow

打开jupyter，切换内核<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/39147835/1725286360582-cf87dbbf-9089-452e-88d3-8529d7d4d819.png#averageHue=%23dfdfdf&clientId=u58c5e0a0-b092-4&from=paste&height=190&id=ufb669385&originHeight=365&originWidth=590&originalType=binary&ratio=1.9199999570846558&rotation=0&showTitle=false&size=35689&status=done&style=none&taskId=uab0c64d4-4f8f-4a58-8404-eab22097033&title=&width=307.2916735351708)
