using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePointDraw : MonoBehaviour {
    [SerializeField] private GameObject targetObj;

    void Start() {
    }

    void Update() {

        //  オブジェクトにRayを飛ばす
        //  マウスの座標を取得
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 300.0f)) {
            targetObj.GetComponent<Renderer>().material.SetFloat("_ClickPosX", hit.point.x);
            targetObj.GetComponent<Renderer>().material.SetFloat("_ClickPosY", hit.point.y);
            targetObj.GetComponent<Renderer>().material.SetFloat("_ClickPosZ", hit.point.z);
        }

    }
}
