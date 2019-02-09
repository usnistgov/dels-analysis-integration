sd1 = Storage_Department;
sd1.aisles = 51;
sd1.aisle_width = 30;
sd1.k = 50;
sd1.orientation = pi;
sd1.offset = [51*30, 1000+15];
sd1.aisle_length = 1000-Parametric_Ellipse(0.5*sd1.aisle_width:sd1.aisle_width:sd1.aisle_width*(sd1.aisles-1)+0.5*sd1.aisle_width);
sd1.GeneratePickerNetwork;

sd2 = Storage_Department;
sd2.aisles = 51;
sd2.aisle_width = 30;
sd2.aisle_length = Parametric_Ellipse(0.5*sd2.aisle_width:sd2.aisle_width:sd2.aisle_width*(sd2.aisles-1)+0.5*sd2.aisle_width);
sd2.k = 50;
sd2.orientation = 0;
sd2.offset = [0,0];
sd2.GeneratePickerNetwork;

sd2 = Storage_Department;
sd2.aisles = floor(1000/30);
sd2.aisle_width = 30;
x = 0:sd2.aisle_width:sd2.aisle_width*(sd2.aisles-1)+0.5*sd2.aisle_width;
sd2.aisle_length = x*(750/1000);%tan((24*sd2.aisle_width)/1000);
sd2.k = 50;
sd2.orientation = 3*pi/2;
sd2.offset = [0,sd2.aisle_width*(sd2.aisles)+0.5*sd2.aisle_width];
sd2.GeneratePickerNetwork;

sd3 = Storage_Department;
sd3.aisles = ceil(1000/30);
sd3.aisle_width = 30;
x = 0:sd3.aisle_width:sd3.aisle_width*(sd3.aisles-1)+0.5*sd3.aisle_width;
sd3.aisle_length = 750-x*(750/1000);
sd3.k = 50;
sd3.orientation = pi/2;
sd3.offset = [2*750,0];
sd3.GeneratePickerNetwork;

sd4 = Storage_Department;
sd4.aisles = floor(1000/30);
sd4.aisle_width = 30;
x = 0:sd4.aisle_width:sd4.aisle_width*(sd4.aisles)+0.5*sd4.aisle_width;
sd4.aisle_length = 350*ones(sd4.aisles,1)-0.5*sd4.aisle_width;
sd4.k = 50;
sd4.orientation = 0;
sd4.offset = [0,0];
sd4.GeneratePickerNetwork;

sd5 = Storage_Department;
sd5.aisles = floor(1000/30);
sd5.aisle_width = 30;
x = 0:sd5.aisle_width:sd5.aisle_width*(sd5.aisles)+0.5*sd5.aisle_width;
sd5.aisle_length = 650*ones(sd5.aisles,1)-0.5*sd5.aisle_width;
sd5.k = 50;
sd5.orientation = 0;
sd5.offset = [0,350];
sd5.GeneratePickerNetwork;

sd6 = Storage_Department;
sd6.aisles = 51;
sd6.aisle_width = 30;
x = 0.5*sd6.aisle_width:sd6.aisle_width:sd6.aisle_width*25 + sd6.aisle_width;
sd6.aisle_length = x*(350/(25*30));
sd6.aisle_length = [sd6.aisle_length, fliplr(sd6.aisle_length(1:end-1))];
sd6.k = 50;
sd6.orientation = 0;
sd6.offset = [0,0];
sd6.GeneratePickerNetwork;

sd7 = Storage_Department;
sd7.aisles = 51;
sd7.aisle_width = 30;
x = 0.5*sd7.aisle_width:sd7.aisle_width:sd7.aisle_width*25 + sd7.aisle_width;
sd7.aisle_length = x*(350/(25*30));
sd7.aisle_length = 500-0.25*sd7.aisle_width-[sd7.aisle_length, fliplr(sd7.aisle_length(1:end-1))];
sd7.k = 50;
sd7.orientation = pi;
sd7.offset = [51*30,500+0.25*sd7.aisle_width];
sd7.GeneratePickerNetwork;