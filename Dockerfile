FROM openjdk:8
ADD jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar namtrend.jar
ENTRYPOINT [ "java", "-jar", "namtrend.jar" ]





