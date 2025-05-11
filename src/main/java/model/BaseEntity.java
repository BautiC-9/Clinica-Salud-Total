// Clase abstracta base para entidades con ID
package main.java.model;

import java.io.Serializable;

public abstract class BaseEntity implements Serializable {
    private Integer id;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}