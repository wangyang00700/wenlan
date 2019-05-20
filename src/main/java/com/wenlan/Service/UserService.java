package com.wenlan.Service;

import com.wenlan.Dao.UserMapper;
import com.wenlan.Model.ClientExample;
import com.wenlan.Model.User;
import com.wenlan.Model.UserExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by 59100 on 2019/5/16.
 */
@Service
@Transactional
public class UserService {

    @Autowired
    UserMapper userMapper;

    public Map<String, Object> getAll() {
        Map<String, Object> map = new HashMap<>();
        map.put("list", userMapper.selectByExample(new UserExample()));
        map.put("code", 1);
        return map;
    }

    public Map<String, Object> Login(String username, String password, HttpSession httpSession) {
        Map<String, Object> map = new HashMap<>();
        UserExample userExample = new UserExample();
        userExample.or().andUsernameEqualTo(username).andPasswordEqualTo(password);
        List<User> users = userMapper.selectByExample(userExample);
        if (users.size() != 0) {
            httpSession.setAttribute("user", users.get(0));
            httpSession.setAttribute("type", users.get(0).getType());
            map.put("code", 1);
            map.put("type", users.get(0).getType());
            return map;
        }
        map.put("code", 0);
        map.put("text", "账号或密码错误!!");
        return map;
    }

    public Map<String, Object> insert(User user) {
        Map<String, Object> map = new HashMap<>();
        UserExample userExample = new UserExample();
        userExample.or().andUsernameEqualTo(user.getUsername());
        int count = userMapper.countByExample(userExample);
        if (count != 0) {
            map.put("code", 0);
            map.put("msg", "账户重复");
            return map;
        }
        user.setType(1);
        userMapper.insert(user);
        map.put("code", 1);
        return map;
    }

    public Map<String, Object> lookUser(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", (page - 1) * limit);
        data.put("limit", limit);
        data.put("type", 1);
        List<User> users = userMapper.queryUserBySys(data);
        map.put("code", 0);
        map.put("data", users);
        map.put("limit", limit);
        UserExample userExample = new UserExample();
        userExample.or().andTypeEqualTo(1);
        map.put("count", userMapper.countByExample(userExample));
        return map;
    }

    public Map<String, Object> update(String data) {
        Map<String, Object> map = new HashMap<>();
        data = data.substring(1);
        String datas[] = data.split(",");
        for (int i = 0; i < datas.length; ) {
            User user = new User();
            user.setUid(Integer.parseInt(datas[i++]));
            user.setDtype(Integer.parseInt(datas[i++]));
            user.setCount(Integer.parseInt(datas[i++]));
            userMapper.updateByPrimaryKeySelective(user);
        }
        map.put("code", 1);
        return map;
    }

    public Map<String, Object> getUser(int uid, HttpSession httpSession) {
        Map<String, Object> map = new HashMap<>();
        User user=userMapper.selectByPrimaryKey(uid);
        httpSession.setAttribute("user", user);
        map.put("code", 1);
        map.put("user", user);
        return map;
    }

    public Map<String, Object> delete(int uid) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", userMapper.deleteByPrimaryKey(uid));
        return map;
    }
}

