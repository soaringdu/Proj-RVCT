chann=1;  //输入钙通道序号
z_projection_start=0 ;
z_projection_end=40 ;

fa_path = getDirectory("Choose the Input Directory");
file_list=getFileList(fa_path);	
 	for (l = 0; l < file_list.length; l++){
		if (endsWith(file_list[l],".tif")){
			name=substring(file_list[l], 0, lengthOf(file_list[l])-4);
			run("Bio-Formats Importer", "open="+fa_path+file_list[l]+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			raw=getTitle();
			getDimensions(width, height, channels, slices, frames);
			
			for (z = 1; z < slices+1; z++) {
				selectWindow(raw);
				
				run("Duplicate...", "duplicate channels="+chann+" slices="+z);
				rename("slice");
				run("Z Project...", "start="+z_projection_start+" stop="+z_projection_end+" projection=[Average Intensity]");  //run("Z Project...", "start=230 stop=300 projection=[Average Intensity]");
				rename("slice_pro");
				imageCalculator("Copy create stack", "slice","slice_pro");
				rename("result");
				run("MultiStackReg", "stack_1=[result] action_1=[Use as Reference] file_1=[] stack_2=[slice] action_2=[Align to First Stack] file_2=[] transformation=[Rigid Body]");
				selectWindow("slice");
				saveAs("Tiff",fa_path+"aligned_"+z+"_"+name+".tif");
				close("slice");
				close("slice_pro");
				close("result");
				
			}
			
			
		close("*");
		}
	}
