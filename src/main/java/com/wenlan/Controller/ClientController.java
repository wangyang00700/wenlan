package com.wenlan.Controller;

import com.wenlan.Service.ClientService;
import com.wenlan.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2019/1/6.
 */
@RequestMapping("/client")
@Controller
public class ClientController {

    @Autowired
    ClientService clientService;

    @ResponseBody
    @RequestMapping("/getall")
    public Map<String, Object> getAll() {
        return clientService.getAll();
    }


    @ResponseBody
    @RequestMapping("/upload")
    public Map<String, Object> getExcel(@RequestParam("excel") MultipartFile file, HttpServletRequest request) {
        return clientService.ajaxUploadExcel(file);
    }

    @ResponseBody
    @RequestMapping("/getdata")
    public Map<String, Object> queryClientsBySys(int page, int limit) {
        return clientService.queryClientsBySys(page,limit);
    }
}
