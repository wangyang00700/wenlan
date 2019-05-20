package com.wenlan.Controller;

import com.wenlan.Model.User;
import com.wenlan.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2019/1/6.
 */
@RequestMapping("/user")
@Controller
public class UserController {

    @Autowired
    UserService userService;

    @ResponseBody
    @RequestMapping("/getall")
    public Map<String, Object> getAll() {
        return userService.getAll();
    }

    @ResponseBody
    @RequestMapping("/login")
    public Map<String, Object> login(@RequestParam(value = "username") String username, @RequestParam(value = "password") String password, HttpSession httpSession, HttpServletRequest request) {
        return userService.Login(username, password, httpSession);
    }

    @ResponseBody
    @RequestMapping("/insert")
    public Map<String, Object> insert(User user) {
        return userService.insert(user);
    }

    @ResponseBody
    @RequestMapping("/lookUser")
    public Map<String, Object> lookUser(int page, int limit) {
        return userService.lookUser(page, limit);
    }

    @ResponseBody
    @RequestMapping("/update")
    public Map<String, Object> update(String data) {
        return userService.update(data);
    }

    @ResponseBody
    @RequestMapping("/getUser")
    public Map<String, Object> getUser(int uid, HttpSession httpSession) {
        return userService.getUser(uid, httpSession);
    }

    @ResponseBody
    @RequestMapping("/delete")
    public Map<String, Object> delete(int uid) {
        return userService.delete(uid);
    }
}
