############################################
           # MAPEO  EN R
############################################

#################
  # LIBRERIAS
#################
library(rgdal)
library(RColorBrewer)
library(classInt)

############################################
#           provincias
############################################
getwd()
setwd("F:/cursos/QGIS/insumos - basico/CAP 3/Descarga Peru/")
poligonos<- readOGR("Limite_departamental.shp",layer ="Limite_departamental")
plot(poligonos)
View(poligonos@data) #tabla de atributos
labels<- substr(poligonos@data[,1],1,4)

#calculo de los centroides
centroides<- coordinates(poligonos)
plot(poligonos)
text(centroides,labels, cex= 0.4) #colocamos las etiquetas

#entrada de la tabla excel que se unira a la tabla de atributos
setwd("F:/cursos/QGIS/insumos - basico/CAP 7/INSUMOS/")
library(readxl)
data<- read.csv("Poblacion2.csv",header = T,sep = ";") 
View(data)
data$DEPARTAMENTO<-poligonos@data$NOMBDEP
data<-as.data.frame(data)
row.names(data)<- row.names(poligonos)
poligonos.data<- SpatialPolygonsDataFrame(poligonos,data) #se une y se convierte en un objeto s4(parecido a una lista)

caracteristica<- poligonos.data$POBLACION
w<-5 #cantidad de intervalos
paleta<- brewer.pal(w,"Blues") #defino la paleta de colores y los intervalos
clas<- classIntervals(caracteristica,w,style = "quantile") #aqui fijamos los decimales de la leyenda
colcode <- findColours(clas,paleta) #aqui defino la relacion entre los intervalos en numeros y la paleta de colores

setwd("C:/Users/HP/Desktop/practicando r/")
jpeg("primer mapa en r.jpg",quality = 100,height = 600,width = 800)
plot(poligonos.data,col=colcode, border="Black",axes= T)
title(main = "DISTRIBUCION DE LA POBLACIÓN EN EL PERU",cex=3)
legend("bottomright", legend = names(attr(colcode,"table")),
       fill= attr(colcode,"palette"),cex=1.2)
text(centroides,labels, cex= 0.4)
dev.off()
