package com.wenlan.Service;

import com.github.pagehelper.PageHelper;
import com.wenlan.Dao.ClientMapper;
import com.wenlan.Dao.UserMapper;
import com.wenlan.Model.*;
import com.wenlan.Utils.DateTimeUtil;
import com.wenlan.Utils.ExcelUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import javax.xml.crypto.Data;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

/**
 * Created by 59100 on 2019/5/16.
 */
@Service
@Transactional
public class ClientService {

    @Autowired
    ClientMapper clientMapper;
    @Autowired
    UserService userService;

    public Map<String, Object> getAll() {
        Map<String, Object> map = new HashMap<>();
        map.put("list", clientMapper.selectByExample(new ClientExample()));
        map.put("code", 1);
        return map;
    }

    //管理员获取所有实时表资料
    public Map<String, Object> queryClientsBySys(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        PageHelper.startPage(page, limit);
        List<Client> list = clientMapper.selectByExample(new ClientExample());
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(new ClientExample()));
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidNotEqualTo(0);
        map.put("okcount", clientMapper.countByExample(clientExample));
        return map;
    }

    //用户查看所有未购买客户资料
    public Map<String, Object> queryAllByUser(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidEqualTo(0);
        PageHelper.startPage(page, limit);
        List<Client> list = clientMapper.selectByExample(clientExample);
        String time = DateTimeUtil.getCurrentDate3();
        for (Client item : list) {
            String tel = item.getTel();
            item.setTel(tel.substring(0, 3) + "****" + tel.substring(7, tel.length()));
            if (item.getDate().equals(time)) {
                item.setDate("今天");
            }

        }
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(clientExample));
        return map;
    }

    public Map<String, Object> queryClientsByUser(int page, int limit, int uid) {
        Map<String, Object> map = new HashMap<>();
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidEqualTo(uid);
        PageHelper.startPage(page, limit);
        List<Client> list = clientMapper.selectByExample(clientExample);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(clientExample));
        return map;
    }

    //导出时获取该用户所有客户
    public Map<String, Object> queryClientsByUserAll(int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("uid", uid);
        List<DataSimple> list = clientMapper.queryClientsByUserAll(data);
        map.put("code", 1);
        map.put("data", list);
        return map;
    }

    public Map<String, Object> setClientByuid(int uid, String cids) {
        User user = userService.getUser(uid);
        //当用户提取量不够时
        if (user.getCount() <= 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "用户提取量不足,请联系管理员充值");
            return map;
        }
        cids = cids.substring(1);
        String datas[] = cids.split(",");
        if (datas.length > user.getCount()) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "提取量不足" + datas.length + ",请重新选择客户");
            return map;
        }
        List<String> list = new ArrayList<>();
        for (String s : datas) {
            list.add(s);
        }
        List<DataUModel> data = clientMapper.queryClientsByUserLitle(list);
        for (DataUModel model : data) {
            model.setUid(uid);
        }
        clientMapper.updateSome(data);
        data = clientMapper.queryClientsByUserLitle(list);
        int upCount = 0;
        for (DataUModel model : data) {
            if (model.getUid() == uid)
                upCount++;
        }
        user.setCount(user.getCount() - upCount);
        userService.updateUser(user);
        if (upCount < datas.length) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 2);
            map.put("msg", "购买部分成功,剩余请看提取量");
            return map;
        } else {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 1);
            map.put("msg", "购买成功");
            return map;
        }
    }
//    public Map<String, Object> setClientByuid(int uid) {
//        User user = userService.getUser(uid);
//        //当用户提取量不够时
//        if (user.getCount() <= 0) {
//            Map<String, Object> map = new HashMap<>();
//            map.put("code", 0);
//            map.put("msg", "用户提取量不足,请联系管理员充值");
//            return map;
//        }
//
//        ClientExample clientExample = new ClientExample();
//        clientExample.or().andUidEqualTo(0);
//        if (clientMapper.countByExample(clientExample) < user.getCount()) {
//            Map<String, Object> map = new HashMap<>();
//            map.put("code", 0);
//            map.put("msg", "库存不够,请联系管理员补充");
//            return map;
//        }
//
//        int datacount = user.getCount();
//        Calendar calendar = null;
//        //每分钟出资源数
//        int timeLimit = 30;
//        if (datacount <= 1500)
//            calendar = DateTimeUtil.getBeforeHourTime(1);
//        else if (datacount > 1500)
//            calendar = DateTimeUtil.getBeforeHourTime(2);
//        String time = DateTimeUtil.getNextMinuteTime(calendar, 0);
//        //获取所有资源
//        Map<String, Object> m = new HashMap();
//        m.put("uid", uid);
//        m.put("value", 0);
////        int j = 1;
//        //循环判断
//        while (datacount > 0) {
//            m.put("limit", datacount);
//            List<DataUModel> datas = clientMapper.queryClientsByUserLitle(m);
//            if (datas.size() == 0) break;
//            for (int i = 0; i < datas.size(); i++) {
//                datas.get(i).setUid(uid);
////                if (j++ % timeLimit == 0)
////                    time = DateTimeUtil.getNextMinuteTime(calendar, 1);
////                datas.get(i).setDate(time);
//            }
//            clientMapper.updateSome(datas);
//            ClientExample clientExample1 = new ClientExample();
//            clientExample1.or().andUidEqualTo(uid);
//            int count = clientMapper.countByExample(clientExample1);
//            if (count == datacount)
//                datacount = 0;
//            else datacount = datacount - count;
//        }
//        user.setCount(datacount);
//        userService.updateUser(user);
//        if (datacount > 0) {
//            Map<String, Object> map = new HashMap<>();
//            map.put("code", 2);
//            map.put("msg", "获取成功,库存临时不够,只提取一部分,剩余请看提取量");
//            return map;
//        } else {
//            Map<String, Object> map = new HashMap<>();
//            map.put("code", 1);
//            map.put("msg", "获取成功");
//            return map;
//        }
//    }

    public Map<String, Object> delete(int type) {
        Map<String, Object> map = new HashMap<>();
        //删除所有数据
        if (type == 0) {
            clientMapper.deleteByExample(new ClientExample());
        }
        //删除已提取数据
        else if (type == 1) {
            ClientExample clientExample = new ClientExample();
            clientExample.or().andUidNotEqualTo(0);
            clientMapper.deleteByExample(clientExample);
        }
        map.put("code", 1);
        return map;
    }

    /*******************************************************************************/

    //解析Excel
    public Map<String, Object> ajaxUploadExcel(MultipartFile file) {
        Map<String, Object> map = new HashMap<>();

        if (file.isEmpty()) {
            try {
                throw new Exception("文件不存在！");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        InputStream in = null;
        try {
            in = file.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<List<Object>> listob = null;
        List<Client> clients = new ArrayList<>();
        try {
            listob = new ExcelUtils().getBankListByExcel(in, file.getOriginalFilename());
            for (int i = 0; i < listob.size(); i++) {
                List<Object> lo = listob.get(i);
                Client client = new Client();
                client.setName(String.valueOf(lo.get(0)));
                client.setTel(String.valueOf(lo.get(1)));
                client.setUid(0);
                client.setStatus(0);
                client.setVersion("1");
                client.setDate(DateTimeUtil.getCurrentDate("yyyy/MM/dd"));
                clients.add(client);
            }
            clientMapper.insertSome(clients);
            map.put("code", 1);
            map.put("text", "导入成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code", 0);
            map.put("text", e.getMessage());
        }
        return map;
    }

    /*******************************************************************************/
}
