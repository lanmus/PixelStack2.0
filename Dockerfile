FROM maven:3.8-openjdk-8 AS builder

# 设置 Maven 阿里云镜像
COPY settings.xml /usr/share/maven/ref/
WORKDIR /build

# 复制 pom.xml
COPY pom.xml .

# 下载依赖
RUN mvn dependency:go-offline -DskipTests

# 复制源代码
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests

FROM openjdk:8-jre-alpine

WORKDIR /app

# 从builder阶段复制构建好的jar
COPY --from=builder /build/target/ims_pixelStack.jar .

# 创建存储图片的目录
RUN mkdir -p /home/pixelstack_upload

# 暴露端口
EXPOSE 8213

# 启动命令
CMD ["java", "-jar", "ims_pixelStack.jar"]