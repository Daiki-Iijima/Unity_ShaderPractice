using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeShaderValuesSample : MonoBehaviour {

    private void Start() {
        this.gameObject.GetComponent<Renderer>().material.SetColor("_BaseColor", Color.red);
    }

    private void Update() {
    }
}
