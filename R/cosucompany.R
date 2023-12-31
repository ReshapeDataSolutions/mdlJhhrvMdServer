#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' btn_preview_CosucompanyServer()
#'
btn_preview_CosucompanyServer <- function(input,output,session,dms_token) {

  var_file_expInfo_Cosucompany=tsui::var_file(id='file_expInfo_Cosucompany')


  shiny::observeEvent(input$btn_preview_Cosucompany,{
    
    
    if(!is.null(var_file_expInfo_Cosucompany())){
      filename=var_file_expInfo_Cosucompany()
      
      data <- readxl::read_excel(filename,sheet = "往来单位", col_types = c("text","text","text"))
      data=as.data.frame(data)
      data=tsdo::na_standard(data)
      tsui::run_dataTable2(id = 'mdlJHmd_Cosucompany_resultView',data = data)
      
      
    }
    else{
      tsui::pop_notice("请先上传文件")
    }
    

  })


}


#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' btn_Update_CosucompanyServer()
btn_Update_CosucompanyServer <- function(input,output,session,dms_token) {
  var_file_expInfo_Cosucompany=tsui::var_file(id='file_expInfo_Cosucompany')


  shiny::observeEvent(input$'btn_Update_Cosucompany',{
    if(!is.null(var_file_expInfo_Cosucompany())){
      
      filename=var_file_expInfo_Cosucompany()
      data<-readxl::read_excel(filename,sheet = "往来单位", col_types = c("text","text","text"))
      data=as.data.frame(data)
      data=tsdo::na_standard(data)
      #上传至数据库至重分类暂存表
      tsda::db_writeTable2(token = '9ADDE293-1DC6-4EBC-B8A7-1E5CC26C1F6C',table_name = 'rds_hrv_src_md_cosucompany_input',r_object = data,append = TRUE)
      #删除重分类已有数据
      mdlJhhrvMdPkg::deleteCache_cosucompany()
      #将暂存表数据插入重分类
      mdlJhhrvMdPkg::insertCache_cosucompany()
      #删除重分类暂存表数据
      mdlJhhrvMdPkg::deleteAllcache_cosucompany()
      tsui::pop_notice("往来单位更新成功")
      
    }
    else{
      tsui::pop_notice("请先上传文件")
    }



  })
}

#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' btn_preview_CosucompanyServer()
#'
btn_download_CosucompanyServer <- function(input,output,session,dms_token) {
  
  shiny::observeEvent(input$btn_view_Cosucompany,{
    data_Cosucompany = mdlJhhrvMdPkg::ViewCosucompany()
    
    tsui::run_dataTable2(id = 'mdlJHmd_Cosucompany_resultView',data =data_Cosucompany )
    
    
    #下载数据
    tsui::run_download_xlsx(id = 'mdlJHmd_Cosucompany_resultView',data =data_Cosucompany ,filename = '往来单位数据.xlsx')
    
    
  })
  
  
}



#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' CosucompanyServer()
CosucompanyServer <- function(input,output,session,dms_token) {
  #演示功用1
  btn_preview_CosucompanyServer(input,output,session,dms_token)
  #演示功能2
  btn_Update_CosucompanyServer(input,output,session,dms_token)
  btn_download_CosucompanyServer(input,output,session,dms_token)



}
