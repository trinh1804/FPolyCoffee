package com.entity;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "BILLDETAIL")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class BillDetail {

    @EmbeddedId
    private BillDetailId id;

    @Column(name = "quantity", nullable = false)
    private int quantity;

    @Column(name = "unit_price", nullable = false)
    private double unitPrice;

    @Column(name = "total_price", nullable = false)
    private double totalPrice;

    // ─── Convenience getters/setters để các DAO cũ tiếp tục dùng ──────────

    public Integer getBillId() {
        return id != null ? id.getBillId() : null;
    }

    public Integer getDrinkId() {
        return id != null ? id.getDrinkId() : null;
    }

    public void setBillId(Integer billId) {
        if (id == null)
            id = new BillDetailId();
        id.setBillId(billId);
    }

    public void setDrinkId(Integer drinkId) {
        if (id == null)
            id = new BillDetailId();
        id.setDrinkId(drinkId);
    }

    /** Constructor tiện lợi dùng billId + drinkId riêng lẻ */
    public BillDetail(Integer billId, Integer drinkId,
            int quantity, double unitPrice, double totalPrice) {
        this.id = new BillDetailId(billId, drinkId);
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
    }
}