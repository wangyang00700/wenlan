package com.wenlan.Dao;

import com.wenlan.Model.Client;
import com.wenlan.Model.ClientExample;

import java.util.List;
import java.util.Map;

import com.wenlan.Model.DataSimple;
import com.wenlan.Model.DataUModel;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.stereotype.Repository;

@MapperScan
@Repository
public interface ClientMapper {
    int countByExample(ClientExample example);

    int deleteByExample(ClientExample example);

    int deleteByPrimaryKey(Integer cid);

    int insert(Client record);

    int insertSelective(Client record);

    List<Client> selectByExample(ClientExample example);

    Client selectByPrimaryKey(Integer cid);

    int updateByExampleSelective(@Param("record") Client record, @Param("example") ClientExample example);

    int updateByExample(@Param("record") Client record, @Param("example") ClientExample example);

    int updateByPrimaryKeySelective(Client record);

    int updateByPrimaryKey(Client record);

    //导出用
    List<DataSimple> queryClientsByUserAll(Map<String, Object> data);

    //获取用
    List<DataUModel> queryClientsByUserLitle(List<String> list);

    int insertSome(List<Client> clients);

    int updateSome(List<DataUModel> clients);
}