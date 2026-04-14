package com.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Embeddable
@AllArgsConstructor
@NoArgsConstructor
@Data
public class BillDetailId implements Serializable {

    @Column(name = "bill_id")
    private Integer billId;

    @Column(name = "drink_id")
    private Integer drinkId;
}