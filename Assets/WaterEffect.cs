using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterEffect : MonoBehaviour {
    [Header("Options")]
    [SerializeField]
    private float m_offset;


    GameObject quad;
	// Use this for initialization
	void Start () {
        quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
