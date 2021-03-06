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
    public Map<String, Object> getExcel(@RequestParam("excel") MultipartFile file,
                                        @RequestParam("startDate") String startDate,
                                        @RequestParam("endDate") String endDate,
                                        HttpServletRequest request) {
        return clientService.ajaxUploadExcel(file,startDate,endDate);
    }

    @ResponseBody
    @RequestMapping("/getdata")
    public Map<String, Object> queryClientsBySys(int page, int limit) {
        return clientService.queryClientsBySys(page, limit);
    }

    @ResponseBody
    @RequestMapping("/getAllByUser")
    public Map<String, Object> queryAllByUser(int page, int limit) {
        return clientService.queryAllByUser(page, limit);
    }

    @ResponseBody
    @RequestMapping("/getUserdata")
    public Map<String, Object> getUserdata(int page, int limit, int uid) {
        return clientService.queryClientsByUser(page, limit, uid);
    }

    @ResponseBody
    @RequestMapping("/getUserdataAll")
    public Map<String, Object> getUserdataAll(int uid) {
        return clientService.queryClientsByUserAll(uid);
    }

    @ResponseBody
    @RequestMapping("/delete")
    public Map<String, Object> delete(@RequestParam("type") int type) {
        return clientService.delete(type);
    }

    @ResponseBody
    @RequestMapping("/setClientByuid")
    public Map<String, Object> setClientByuid(int uid, String cids) {
        return clientService.setClientByuid(uid, cids);
    }
}
