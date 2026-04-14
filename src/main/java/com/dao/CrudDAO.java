package com.dao;

import java.util.List;

/**
 * Interface CRUD chung cho tất cả DAO.
 * Giữ nguyên contract cũ để các Servlet không cần sửa.
 */
public interface CrudDAO<Entity, ID> {
    int create(Entity entity);

    int update(Entity entity);

    int delete(ID id);

    List<Entity> findAll();

    Entity findById(ID id);

    List<Entity> findBySql(String jpql, Object... values);
}