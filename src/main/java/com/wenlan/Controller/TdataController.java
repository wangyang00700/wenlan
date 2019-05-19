package com.wenlan.Controller;

import com.wenlan.Service.ClientService;
import com.wenlan.Service.TdataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by Administrator on 2019/1/6.
 */
@RequestMapping("/tdata")
@Controller
public class TdataController {

    @Autowired
    TdataService tdataService;

    @ResponseBody
    @RequestMapping("/getall")
    public Map<String, Object> getAll() {
        return tdataService.getAll();
    }


    @ResponseBody
    @RequestMapping("/upload")
    public Map<String, Object> getExcel(@RequestParam("excel") MultipartFile file, HttpServletRequest request) {
        return tdataService.ajaxUploadExcel(file);
    }

    @ResponseBody
    @RequestMapping("/getdata")
    public Map<String, Object> queryClientsBySys(int page, int limit) {
        return tdataService.queryClientsBySys(page, limit);
    }

    @ResponseBody
    @RequestMapping("/delete")
    public Map<String, Object> delete(@RequestParam("type") int type) {
        return tdataService.delete(type);
    }
}
