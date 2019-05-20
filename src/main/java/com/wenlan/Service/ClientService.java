package com.wenlan.Service;

import com.wenlan.Dao.ClientMapper;
import com.wenlan.Dao.UserMapper;
import com.wenlan.Model.Client;
import com.wenlan.Model.ClientExample;
import com.wenlan.Model.User;
import com.wenlan.Model.UserExample;
import com.wenlan.Utils.ExcelUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by 59100 on 2019/5/16.
 */
@Service
@Transactional
public class ClientService {

    @Autowired
    ClientMapper clientMapper;
    @Autowired
    UserMapper userMapper;

    public Map<String, Object> getAll() {
        Map<String, Object> map = new HashMap<>();
        map.put("list", clientMapper.selectByExample(new ClientExample()));
        map.put("code", 1);
        return map;
    }

    public Map<String, Object> queryClientsBySys(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", (page - 1) * limit);
        data.put("limit", limit);
        List<Client> list = clientMapper.queryClientsBySys(data);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(new ClientExample()));
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidNotEqualTo(0);
        int count = clientMapper.countByExample(clientExample);
        map.put("okcount", clientMapper.countByExample(clientExample));
        return map;
    }

    public Map<String, Object> queryClientsByUser(int page, int limit, int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", (page - 1) * limit);
        data.put("limit", limit);
        data.put("uid", uid);
        List<Client> list = clientMapper.queryClientsByUser(data);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidEqualTo(uid);
        map.put("count", clientMapper.countByExample(clientExample));
//        ClientExample clientExample = new ClientExample();
//        clientExample.or().andUidNotEqualTo(0);
//        int count = clientMapper.countByExample(clientExample);
//        map.put("okcount", clientMapper.countByExample(clientExample));
        return map;
    }

    public Map<String, Object> queryClientsByUserAll(int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", 0);
        User user = userMapper.selectByPrimaryKey(uid);
        data.put("limit", user.getCount());
        data.put("uid", uid);
        List<Client> list = clientMapper.queryClientsByUserAll(data);
        map.put("code", 1);
        map.put("data", list);
        return map;
    }

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
        try {
            listob = new ExcelUtils().getBankListByExcel(in, file.getOriginalFilename());

            for (int i = 0; i < listob.size(); i++) {
                List<Object> lo = listob.get(i);
                Client client = new Client();
                client.setName(String.valueOf(lo.get(0)));
                client.setTel(String.valueOf(lo.get(1)));
                client.setUid(0);
                client.setStatus(0);
                clientMapper.insertSelective(client);
            }
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
